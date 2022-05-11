//
//  QueryRequest.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

public struct QueryRequest: Request {
    // MARK: - Property
    private let parameter: [String: String]
    
    // MARK: - Initializer
    public init(_ parameter: [String: String]) {
        self.parameter = parameter
    }
    
    // MARK: - Public
    public func make(url: URL) throws -> URLRequest {
        guard var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL(url.absoluteString)
        }
        
        components.queryItems = parameter.map { .init(name: $0, value: $1) }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL(url.absoluteString)
        }
        
        return URLRequest(url: url)
    }
    
    // MARK: - Private
}
