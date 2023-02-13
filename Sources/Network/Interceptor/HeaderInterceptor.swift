//
//  HeaderInterceptor.swift
//  
//
//  Created by jsilver on 2022/01/23.
//

import Foundation

public struct HeaderInterceptor: Interceptor {
    // MARK: - Property
    private let key: String
    private let value: () -> String?
    
    // MARK: - Initializer
    public init(key: String, value: @escaping () -> String?) {
        self.key = key
        self.value = value
    }
    
    public init(key: String, value: String) {
        self.init(key: key) { value }
    }
    
    // MARK: - Public
    public func request(
        _ request: URLRequest,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: any TargetSessionTask,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var request = request
        request.setValue(value(), forHTTPHeaderField: key)
        
        completion(.success(request))
    }
    
    // MARK: - Private
}
