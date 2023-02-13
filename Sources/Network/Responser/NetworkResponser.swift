//
//  NetworkResponser.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public protocol NetworkResponser {
    var provider: any NetworkProvider { get }
    
    init(provider: any NetworkProvider)
    
    func response<T: Target>(
        target: T,
        result: Response,
        handler: (Result<T.Result, Error>) -> Void
    )
}

public extension NetworkResponser {
    @discardableResult
    func request<T: Target>(
        _ target: T,
        sessionTask: (any TargetSessionTask)? = nil,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil,
        completion: @escaping (Result<T.Result, Error>) -> Void
    ) -> any SessionTask {
        provider.request(
            target,
            sessionTask: sessionTask,
            progress: progress,
            requestModifier: requestModifier
        ) {
            response(
                target: target,
                result: $0,
                handler: completion
            )
        }
    }
}

public extension NetworkResponser {
    @discardableResult
    func request<T: Target>(
        _ target: T,
        sessionTask: (any TargetSessionTask)? = nil,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> T.Result {
        try await withUnsafeThrowingContinuation { continuation in
            request(target) {
                switch $0 {
                case let .success(result):
                    continuation.resume(returning: result)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
