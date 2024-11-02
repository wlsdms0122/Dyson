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
    private let isEncoded: Bool
    
    // MARK: - Initializer
    public init(_ parameter: [String: String], isEncoded: Bool = false) {
        self.parameter = parameter
        self.isEncoded = isEncoded
    }
    
    // MARK: - Public
    public func make(url: URL) throws -> URLRequest {
        guard var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )
        else {
            throw DysonError.invalidURL
        }
        
        if isEncoded {
            components.percentEncodedQueryItems = parameter.map { .init(name: $0, value: $1) }
        } else {
            components.queryItems = parameter.map { .init(name: $0, value: $1) }
        }
        
        guard let url = components.url else {
            throw DysonError.invalidURL
        }
        
        return URLRequest(url: url)
    }
    
    // MARK: - Private
}

public extension Request {
    static func query(
        _ parameter: [String: String],
        isEncoded: Bool = false
    ) -> Self where Self == QueryRequest {
        QueryRequest(parameter, isEncoded: isEncoded)
    }
}
