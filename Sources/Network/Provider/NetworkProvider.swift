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
        progress: ((Progress) -> Void)?,
        requestModifier: ((URLRequest) -> URLRequest)?,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask
}

public extension NetworkProvider {
    @discardableResult
    func request(
        _ target: some Target,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask {
        request(
            target,
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
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> (Data, URLResponse) {
        try await withUnsafeThrowingContinuation { continuation in
            request(
                target,
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
