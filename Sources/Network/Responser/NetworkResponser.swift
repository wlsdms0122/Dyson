//
//  NetworkResponser.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public protocol NetworkResponser: AnyObject {
    var networkProvider: NetworkProvidable { get }
    
    func response<T: Target>(
        target: T,
        data: Data?,
        response: URLResponse?,
        error: Error?,
        handler: (Result<T.Result, Error>) -> Void
    )
}

public extension NetworkResponser {
    @discardableResult
    func request<T: Target>(
        _ target: T,
        progress: ((Progress) -> Void)? = nil,
        completion: @escaping (Result<T.Result, Error>) -> Void
    ) -> URLSessionTask? {
        networkProvider.request(target, progress: progress) { [weak self] data, response, error in
            self?.response(
                target: target,
                data: data,
                response: response,
                error: error,
                handler: completion
            )
        }
    }
}

public extension NetworkResponser {
    @discardableResult
    func request<T: Target>(
        _ target: T,
        progress: ((Progress) -> Void)? = nil
    ) async throws -> (T.Result) {
        let result: (data: Data?, response: URLResponse?, error: Error?)
        do {
            let (data, response) = try await networkProvider.request(target, progress: progress)
            result = (data, response, nil)
        } catch {
            result = (nil, nil, error)
        }
        
        return try await withUnsafeThrowingContinuation { [weak self] continuation in
            self?.response(
                target: target,
                data: result.data,
                response: result.response,
                error: result.error
            ) {
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
