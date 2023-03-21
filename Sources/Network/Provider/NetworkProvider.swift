//
//  NetworkProvider.swift
//  
//
//  Created by jsilver on 2022/01/09.
//

import Foundation

public protocol NetworkProvider: AnyObject {
    @discardableResult
    func request(
        _ target: some Target,
        sessionTask: (any TargetSessionTask)?,
        progress: ((Progress) -> Void)?,
        requestModifier: ((URLRequest) -> URLRequest)?,
        completion: @escaping (Response) -> Void
    ) -> any SessionTask
}

public extension NetworkProvider {
    @discardableResult
    func request(
        _ target: some Target,
        sessionTask: (any TargetSessionTask)? = nil,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil,
        completion: @escaping (Response) -> Void
    ) -> any SessionTask {
        request(
            target,
            sessionTask: sessionTask,
            progress: progress,
            requestModifier: requestModifier,
            completion: completion
        )
    }
}

// MARK: - async/await
public extension NetworkProvider {
    @discardableResult
    func request(
        _ target: some Target,
        sessionTask: (any TargetSessionTask)? = nil,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> (Data, URLResponse) {
        try await withUnsafeThrowingContinuation { continuation in
            request(
                target,
                sessionTask: sessionTask,
                progress: progress,
                requestModifier: requestModifier
            ) { result in
                switch result {
                case let .success(result):
                    continuation.resume(returning: result)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

public extension NetworkProvider {
    func responser<Responser: NetworkResponser>(_ responser: Responser.Type) -> Responser {
        responser.init(provider: self)
    }
}
