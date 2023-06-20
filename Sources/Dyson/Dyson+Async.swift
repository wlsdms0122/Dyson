//
//  Dyson+Async.swift
//
//
//  Created by JSilver on 2023/06/16.
//

import Foundation

public extension Dyson {
    @discardableResult
    func response(
        _ spec: some Spec,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            response(
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
    func data<S: Spec>(
        _ spec: S,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> S.Result {
        try await withCheckedThrowingContinuation { continuation in
            data(
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
