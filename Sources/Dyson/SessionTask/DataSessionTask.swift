//
//  SessionDataTask.swift
//  Dyson
//
//  Created by JSilver on 6/1/25.
//

import Foundation

public protocol DataSessionTask: SessionTask {
    func resume(completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void)
    func resume() async throws -> (Data, URLResponse)
}

public extension DataSessionTask {
    func resume(completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void) {
        Task {
            do {
                completion(.success(try await resume()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func resume() async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            resume { result in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
