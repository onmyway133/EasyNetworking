//
//  Future.swift
//  EasyNetworking
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

public class Token {
    private let lock = NSRecursiveLock()
    private var _isCancelled = false
    private var callbacks: [() -> Void] = []
    
    public init() {}

    public func isCancelled() -> Bool {
        return lock.whenLock {
            return _isCancelled
        }
    }
    
    public func cancel() {
        lock.whenLock {
            guard self._isCancelled == false else {
                return
            }

            self._isCancelled = true
            self.callbacks.forEach { $0() }
            self.callbacks.removeAll()
        }
    }
    
    public func onCancel(_ callback: @escaping () -> Void) {
        lock.whenLock {
            self.callbacks.append(callback)
        }
    }
}

public class Resolver<T> {
    public let queue: DispatchQueue
    public let token: Token
    private var callback: (Result<T, Error>) -> Void
    
    public init(queue: DispatchQueue, token: Token, callback: @escaping (Result<T, Error>) -> Void) {
        self.queue = queue
        self.token = token
        self.callback = callback
    }
    
    public func complete(value: T) {
        self.handle(result: .success(value))
    }
    
    public func fail(error: Error) {
        self.handle(result: .failure(error))
    }
    
    public func handle(result: Result<T, Error>) {
        queue.async {
            self.callback(result)
            self.callback = { _ in }
        }
    }
}

public class Future<T> {
    public let work: (Resolver<T>) -> Void
    
    public init(work: @escaping (Resolver<T>) -> Void) {
        self.work = work
    }
    
    public static func fail(error: Error) -> Future<T> {
        return Future<T>.result(.failure(error))
    }
    
    public static func complete(value: T) -> Future<T> {
        return .result(.success(value))
    }
    
    public static func result(_ result: Result<T, Error>) -> Future<T> {
        return Future<T>(work: { resolver in
            switch result {
            case .success(let value):
                resolver.complete(value: value)
            case .failure(let error):
                resolver.fail(error: error)
            }
        })
    }
    
    public func run(queue: DispatchQueue = .serial(), token: Token = Token(), completion: @escaping (Result<T, Error>) -> Void) {
        queue.async {
            if (token.isCancelled()) {
                completion(.failure(NetworkError.cancelled))
                return
            }
            
            let resolver = Resolver<T>(queue: queue, token: token, callback: completion)
            self.work(resolver)
        }
    }
    
    public func map<U>(transform: @escaping (T) -> U) -> Future<U> {
        return Future<U>(work: { resolver in
            self.run(queue: resolver.queue, token: resolver.token, completion: { result in
                resolver.handle(result: result.map(transform))
            })
        })
    }
    
    public func flatMap<U>(transform: @escaping (T) -> Future<U>) -> Future<U> {
        return Future<U>(work: { resolver in
            self.run(queue: resolver.queue, token: resolver.token, completion: { result in
                switch result {
                case .success(let value):
                    let future = transform(value)
                    future.run(queue: resolver.queue, token: resolver.token, completion: { newResult in
                        resolver.handle(result: newResult)
                    })
                case .failure(let error):
                    resolver.fail(error: error)
                }
            })
        })
    }
    
    public func catchError(transform: @escaping (Error) -> Future<T>) -> Future<T> {
        return Future<T>(work: { resolver in
            self.run(queue: resolver.queue, token: resolver.token, completion: { result in
                switch result {
                case .success(let value):
                    resolver.complete(value: value)
                case .failure(let error):
                    let future = transform(error)
                    future.run(queue: resolver.queue, token: resolver.token, completion: { newResult in
                        resolver.handle(result: newResult)
                    })
                }
            })
        })
    }
    
    public func delay(seconds: TimeInterval) -> Future<T> {
        return Future<T>(work: { resolver in
            resolver.queue.asyncAfter(deadline: DispatchTime.now() + seconds, execute: {
                self.run(queue: resolver.queue, token: resolver.token, completion: { result in
                    resolver.handle(result: result)
                })
            })
        })
    }
    
    public func log(closure: @escaping (Result<T, Error>) -> Void) -> Future<T> {
        return Future<T>(work: { resolver in
            self.run(queue: resolver.queue, token: resolver.token, completion: { result in
                closure(result)
                resolver.handle(result: result)
            })
        })
    }
    
    public static func sequence(futures: [Future<T>]) -> Future<Sequence<T>> {
        var index = 0
        var values = [T]()
        
        func runNext(resolver: Resolver<Sequence<T>>) {
            guard index < futures.count else {
                let sequence = Sequence(values: values)
                resolver.complete(value: sequence)
                return
            }
            
            let future = futures[index]
            index += 1
            
            future.run(queue: resolver.queue, token: resolver.token, completion: { result in
                switch result {
                case .success(let value):
                    values.append(value)
                    runNext(resolver: resolver)
                case .failure(let error):
                    resolver.fail(error: error)
                }
            })
        }
        
        return Future<Sequence<T>>(work: runNext)
    }
}

extension NSLocking {
    @inline(__always)
    func whenLock<T>(_ closure: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try closure()
    }

    @inline(__always)
    func whenLock(_ closure: () throws -> Void) rethrows {
        lock()
        defer { unlock() }
        try closure()
    }
}
