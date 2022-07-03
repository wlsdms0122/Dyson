//
//  NetworkProvidable.swift
//  
//
//  Created by jsilver on 2022/01/09.
//

import Foundation

public protocol NetworkProvidable: AnyObject {
    @discardableResult
    func request<T: Target>(
        _ target: T,
        progress: ((Progress) -> Void)?,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionTask?
}

public extension NetworkProvidable {
    @discardableResult
    func request<T: Target>(
        _ target: T,
        progress: ((Progress) -> Void)? = nil,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionTask? {
        request(target, progress: nil, completion: completion)
    }
}

// MARK: - async/await
public extension NetworkProvidable {
    @discardableResult
    func request<T: Target>(
        _ target: T,
        progress: ((Progress) -> Void)? = nil
    ) async throws -> (Data, URLResponse) {
        try await withUnsafeThrowingContinuation { continuation in
            request(target, progress: progress) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let data = data, let response = response else {
                    continuation.resume(throwing: NetworkError.unknown)
                    return
                }

                continuation.resume(returning: (data, response))
            }
        }
    }
}
