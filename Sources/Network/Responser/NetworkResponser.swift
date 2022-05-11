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
        completion: @escaping (Result<T.Result, Error>) -> Void
    ) -> URLSessionTask? {
        request(target, progress: nil, completion: completion)
    }
    
    @discardableResult
    func request<T: Target>(
        _ target: T,
        progress: ((Progress) -> Void)?,
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
