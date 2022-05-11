//
//  Request.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

// MARK: - Request
public protocol Request {
    func make(url: URL) throws -> URLRequest
}

public extension Request {
    func callAsFunction(url: URL) throws -> URLRequest {
        try make(url: url)
    }
}

// MARK: - NoneRequest
public extension Request where Self == NoneRequest {
    static var none: Self { NoneRequest() }
}

// MARK: - QueryRequest
public extension Request where Self == QueryRequest {
    static func query(_ parameter: [String: String]) -> Self {
        QueryRequest(parameter)
    }
}

// MARK: - BodyRequest
public extension Request {
    static func body<Parameter>(_ parameter: Parameter, encoder: Encoder<Parameter>) -> Self where Self == BodyRequest<Parameter> {
        BodyRequest(parameter, encoder: encoder)
    }
}
