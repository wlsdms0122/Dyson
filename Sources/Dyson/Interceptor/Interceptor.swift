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
        dyson: DS,
        spec: some Spec,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<URLRequest>
    )
    
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        dyson: DS,
        spec: some Spec,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<Result<(Data, URLResponse), any Error>>
    )
    
    func result<S: Spec>(
        _ result: Result<S.Result, any Error>,
        dyson: DS,
        spec: S,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<Result<S.Result, any Error>>
    )
}

public extension Interceptor {
    func request(
        _ request: URLRequest,
        dyson: DS,
        spec: some Spec,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<URLRequest>
    ) {
        continuation(request)
    }
    
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        dyson: DS,
        spec: some Spec,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<Result<(Data, URLResponse), any Error>>
    ) {
        continuation(response)
    }
    
    func result<S: Spec>(
        _ result: Result<S.Result, any Error>,
        dyson: DS,
        spec: S,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<Result<S.Result, any Error>>
    ) {
        continuation(result)
    }
}
