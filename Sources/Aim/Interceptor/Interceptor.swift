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
        aim: Aim,
        target: some Target,
        sessionTask: ContainerSessionTask,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    )
    
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        aim: Aim,
        target: some Target,
        sessionTask: ContainerSessionTask,
        completion: @escaping (Result<Result<(Data, URLResponse), any Error>, any Error>) -> Void
    )
    
    func data<T: Target>(
        _ data: Result<T.Result, any Error>,
        aim: Aim,
        target: T,
        sessionTask: ContainerSessionTask,
        completion: @escaping (Result<Result<T.Result, any Error>, any Error>) -> Void
    )
}

public extension Interceptor {
    func request(
        _ request: URLRequest,
        aim: Aim,
        target: some Target,
        sessionTask: ContainerSessionTask,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        completion(.success(request))
    }
    
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        aim: Aim,
        target: some Target,
        sessionTask: ContainerSessionTask,
        completion: @escaping (Result<Result<(Data, URLResponse), any Error>, any Error>) -> Void
    ) {
        completion(.success(response))
    }
    
    func data<T: Target>(
        _ data: Result<T.Result, any Error>,
        aim: Aim,
        target: T,
        sessionTask: ContainerSessionTask,
        completion: @escaping (Result<Result<T.Result, any Error>, any Error>) -> Void
    ) {
        completion(.success(data))
    }
}
