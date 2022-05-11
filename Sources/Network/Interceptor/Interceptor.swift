//
//  Interceptor.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public protocol Interceptor {
    func request<T: Target>(
        _ request: URLRequest,
        session: URLSession,
        target: T
    ) -> URLRequest
    
    func response<T: Target>(
        _ response: URLResponse?,
        data: Data?,
        error: Error?,
        session: URLSession,
        target: T
    )
}
