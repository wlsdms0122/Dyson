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
        var continuation: CheckedContinuation<(Data, URLResponse), Error>?
        let sessionTask = response(
            spec,
            progress: progress,
            requestModifier: requestModifier
        ) { result in
            switch result {
            case let .success(result):
                continuation?.resume(returning: result)
                
            case let .failure(error):
                continuation?.resume(throwing: error)
            }
        }
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation {
                continuation = $0
            }
        } onCancel: {
            sessionTask.cancel()
        }
    }
    
    @discardableResult
    func data<S: Spec>(
        _ spec: S,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> S.Result {
        var continuation: CheckedContinuation<S.Result, Error>?
        let sessionTask = data(
            spec,
            progress: progress,
            requestModifier: requestModifier
        ) { result in
            switch result {
            case let .success(result):
                continuation?.resume(returning: result)
                
            case let .failure(error):
                continuation?.resume(throwing: error)
            }
        }
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation {
                continuation = $0
            }
        } onCancel: {
            sessionTask.cancel()
        }
    }
}
