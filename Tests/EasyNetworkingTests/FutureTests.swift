//
//  FutureTests.swift
//  EasyNetworking-Tests
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import XCTest
import EasyNetworking

class TestError: Error {}

class FutureTests: XCTestCase {
    func testComplete() {
        let expectation = self.expectation(description: #function)
        let future = Future.complete(value: "value")
        future.run(queue: DispatchQueue.serial(), completion: { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, "value")
                expectation.fulfill()
            default:
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFail() {
        let expectation = self.expectation(description: #function)
        let future = Future<Void>.fail(error: TestError())
        future.run(queue: DispatchQueue.serial(), completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is TestError)
                expectation.fulfill()
            default:
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }

    func testMap() {
        let expectation = self.expectation(description: #function)
        let future = Future
            .complete(value: "string")
            .map(transform: { _ in return 10 })

        future.run(queue: DispatchQueue.serial(), completion: { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 10)
                expectation.fulfill()
            default:
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFlatMap() {
        let expectation = self.expectation(description: #function)
        let future = Future
            .complete(value: "string")
            .flatMap(transform: { _ in return Future<Int>.complete(value: 10) })
        
        future.run(queue: DispatchQueue.serial(), completion: { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 10)
                expectation.fulfill()
            default:
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testCatchError() {
        let expectation = self.expectation(description: #function)
        let future = Future<Int>
            .fail(error: TestError())
            .catchError(transform: { _ in return Future.complete(value: 10) })
        
        future.run(queue: DispatchQueue.serial(), completion: { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 10)
                expectation.fulfill()
            default:
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSequence() {
        let expectation = self.expectation(description: #function)
        let futures = [
            Future.complete(value: 1),
            Future.complete(value: 2),
            Future.complete(value: 3).flatMap(transform: { _ in return Future.complete(value: 4) })
        ]
        
        Future.sequence(futures: futures).run(queue: DispatchQueue.serial(), completion: { result in
            switch result {
            case .success(let sequence):
                XCTAssertEqual(sequence.values, [1, 2, 4])
                expectation.fulfill()
            default:
                XCTFail()
            }
        })

        wait(for: [expectation], timeout: 1)
    }
    
    func testSequence2() {
        let expectation = self.expectation(description: #function)
        let futures = [
            Future.complete(value: 1),
            Future.fail(error: TestError()),
            Future.complete(value: 3)
        ]
        
        Future.sequence(futures: futures).run(queue: DispatchQueue.serial(), completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is TestError)
                expectation.fulfill()
            default:
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testDelay() {
        let expectation = self.expectation(description: #function)
        let future = Future
            .complete(value: 10)
            .delay(seconds: 0.5)
        
        future.run(queue: DispatchQueue.serial(), completion: { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 10)
                expectation.fulfill()
            default:
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testCancel() {
        let expectation = self.expectation(description: #function)
        let future = Future
            .complete(value: 10)
            .delay(seconds: 0.5)
        
        let token = Token()
        
        future.run(token: token, completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is NetworkError)
                expectation.fulfill()
            default:
                XCTFail()
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            token.cancel()
        })
        
        wait(for: [expectation], timeout: 0.6)
    }
    
    func testCancel2() {
        let expectation = self.expectation(description: #function)
        let future = Future<Int>(work: { resolver in
            var item: DispatchWorkItem!
            item = DispatchWorkItem(block: {
                XCTAssertTrue(item.isCancelled)
                resolver.complete(value: 10)
            })
            
            resolver.token.onCancel {
                resolver.fail(error: NetworkError.cancelled)
                item.cancel()
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: item)
        })
        
        let token = Token()
        
        future.run(token: token, completion: { result in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error is NetworkError)
                expectation.fulfill()
            default:
                XCTFail()
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
            token.cancel()
        })
        
        wait(for: [expectation], timeout: 1.0)
    }
}
