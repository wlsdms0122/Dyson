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
        sessionTask: any SessionTask,
        continuation: Continuation<URLRequest>
    )
    
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        aim: Aim,
        target: some Target,
        sessionTask: any SessionTask,
        continuation: Continuation<Result<(Data, URLResponse), any Error>>
    )
    
    func result<T: Target>(
        _ result: Result<T.Result, any Error>,
        aim: Aim,
        target: T,
        sessionTask: any SessionTask,
        continuation: Continuation<Result<T.Result, any Error>>
    )
}

public extension Interceptor {
    func request(
        _ request: URLRequest,
        aim: Aim,
        target: some Target,
        sessionTask: any SessionTask,
        continuation: Continuation<URLRequest>
    ) {
        continuation(request)
    }
    
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        aim: Aim,
        target: some Target,
        sessionTask: any SessionTask,
        continuation: Continuation<Result<(Data, URLResponse), any Error>>
    ) {
        continuation(response)
    }
    
    func result<T: Target>(
        _ result: Result<T.Result, any Error>,
        aim: Aim,
        target: T,
        sessionTask: any SessionTask,
        continuation: Continuation<Result<T.Result, any Error>>
    ) {
        continuation(result)
    }
}
