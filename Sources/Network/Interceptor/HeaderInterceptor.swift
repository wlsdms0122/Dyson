//
//  HeaderInterceptor.swift
//  
//
//  Created by jsilver on 2022/01/23.
//

import Foundation

public struct HeaderInterceptor: Interceptor {
    private let key: String
    private let value: () -> String?
    
    public init(key: String, value: @escaping () -> String?) {
        self.key = key
        self.value = value
    }
    
    public init(key: String, value: String) {
        self.init(key: key) { value }
    }
    
    public func request<T: Target>(
        _ request: URLRequest,
        session: URLSession,
        target: T
    ) -> URLRequest {
        var request = request
        request.setValue(value(), forHTTPHeaderField: key)
        
        return request
    }
    
    public func response<T: Target>(
        _ response: URLResponse?,
        data: Data?,
        error: Error?,
        session: URLSession,
        target: T
    ) {
        // Do nothing.
    }
}
