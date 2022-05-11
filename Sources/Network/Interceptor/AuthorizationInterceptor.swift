//
//  AuthenticationInterceptor.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public struct AuthorizationInterceptor: Interceptor {
    private let token: () -> String?
    
    public init(token: @escaping () -> String?) {
        self.token = token
    }
    
    public init(token: String) {
        self.init { token }
    }
    
    public func request<T: Target>(
        _ request: URLRequest,
        session: URLSession,
        target: T
    ) -> URLRequest {
        guard let target = target as? Authorizable, target.needsAuth else { return request }
        
        var request = request
        request.setValue(token(), forHTTPHeaderField: "Authorization")
        
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
