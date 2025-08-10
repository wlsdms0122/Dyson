//
//  Continuation.swift
//
//
//  Created by JSilver on 2023/06/16.
//

import Foundation

public struct Continuation<Value>: Sendable {
    // MARK: - Property
    private let handler: @Sendable (Result<Value, any Error>) -> Void
    
    // MARK: - Initializer
    init(_ handler: @escaping @Sendable (Result<Value, any Error>) -> Void) {
        self.handler = handler
    }
    
    // MARK: - Public
    public func callAsFunction(_ value: Value) {
        resume(value)
    }
    
    public func callAsFunction(throwing error: any Error) {
        resume(throwing: error)
    }
    
    public func resume(_ success: Value) {
        handler(.success(success))
    }
    
    public func resume(throwing error: any Error) {
        handler(.failure(error))
    }
    
    // MARK: - Private
}
