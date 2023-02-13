//
//  Interceptor.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public protocol Interceptor {
    func request(
        _ request: URLRequest,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: TargetSessionTask,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    )
    
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: TargetSessionTask,
        completion: @escaping (Result<Response, any Error>) -> Void
    )
}

public extension Interceptor {
    func request(
        _ request: URLRequest,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: TargetSessionTask,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        completion(.success(request))
    }
    
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: TargetSessionTask,
        completion: @escaping (Result<Response, any Error>) -> Void
    ) {
        completion(.success(response))
    }
}
