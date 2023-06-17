//
//  Aim+Async.swift
//
//
//  Created by JSilver on 2023/06/16.
//

import Foundation

public extension Aim {
    @discardableResult
    func request(
        _ spec: some Spec,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> (Data, URLResponse) {
        try await withUnsafeThrowingContinuation { continuation in
            request(
                spec,
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
    
    @discardableResult
    func response<S: Spec>(
        _ spec: S,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> S.Result {
        try await withUnsafeThrowingContinuation { continuation in
            request(
                spec,
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
