//
//  AuthenticationInterceptor.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public struct AuthorizationInterceptor: Interceptor {
    // MARK: - Property
    private let token: () -> String?
    
    // MARK: - Initializer
    public init(token: @escaping () -> String?) {
        self.token = token
    }
    
    public init(token: String) {
        self.init { token }
    }
    
    // MARK: - Public
    public func request(
        _ request: URLRequest,
        aim: Aim,
        target: some Target,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<URLRequest>
    ) {
        guard let target = target as? Authorizable,
            target.needsAuth else {
            continuation(request)
            return
        }
        
        var request = request
        request.setValue(token(), forHTTPHeaderField: "Authorization")
        
        continuation(request)
    }
    
    // MARK: - Private
}
