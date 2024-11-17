//
//  QueryRequest.swift
//
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

public struct QueryRequest: Request {
    // MARK: - Property
    private let parameter: [String: Any]
    private let isEncoded: Bool
    
    // MARK: - Initializer
    public init(_ parameter: [String: Any], isEncoded: Bool = false) {
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
        
        let queryItems: [URLQueryItem] = parameter.flatMap { key, value in
            if let values = value as? [Any] {
                return values.map { value in URLQueryItem(name: key, value: "\(value)") }
            } else {
                return [URLQueryItem(name: key, value: "\(value)")]
            }
        }
        
        if isEncoded {
            components.percentEncodedQueryItems = queryItems
        } else {
            components.queryItems = queryItems
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
        _ parameter: [String: Any],
        isEncoded: Bool = false
    ) -> Self where Self == QueryRequest {
        QueryRequest(parameter, isEncoded: isEncoded)
    }
}
