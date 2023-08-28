//
//  Dyson+Async.swift
//
//
//  Created by JSilver on 2023/06/16.
//

import Foundation

actor CancellableTask {
    // MARK: - Property
    private var sessionTask: (any SessionTask)?
    
    // MARK: - Initializer
    init() { }
    
    // MARK: - Public
    func perform(_ task: any SessionTask) {
        self.sessionTask = task
    }
    
    func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}

public extension Dyson {
    @discardableResult
    func response(
        _ spec: some Spec,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> (Data, URLResponse) {
        let cancellableTask = CancellableTask()
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                Task {
                    await cancellableTask.perform(
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
                    )
                }
            }
        } onCancel: {
            Task {
                await cancellableTask.cancel()
            }
        }
    }
    
    @discardableResult
    func data<S: Spec>(
        _ spec: S,
        responser: (any Responser)? = nil,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> S.Result {
        let cancellableTask = CancellableTask()
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                Task {
                    await cancellableTask.perform(
                        data(
                            spec,
                            responser: responser,
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
                    )
                }
            }
        } onCancel: {
            Task {
                await cancellableTask.cancel()
            }
        }
    }
}
