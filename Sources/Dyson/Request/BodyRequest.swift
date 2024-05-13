//
//  BodyRequest.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

public struct BodyRequest<Parameter>: Request {
    // MARK: - Property
    private let parameter: Parameter
    private let encoder: Encoder<Parameter>
    
    // MARK: - Initializer
    public init(_ parameter: Parameter, encoder: Encoder<Parameter>) {
        self.parameter = parameter
        self.encoder = encoder
    }
    
    // MARK: - Public
    public func make(url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpBody = try encoder.encode(parameter)
        
        return request
    }
    
    // MARK: - Private
}

public extension Request {
    static func body<Parameter>(
        _ parameter: Parameter,
        encoder: Encoder<Parameter>
    ) -> Self where Self == BodyRequest<Parameter> {
        BodyRequest(parameter, encoder: encoder)
    }
    
    static func body(
        _ parameter: Data
    ) -> Self where Self == BodyRequest<Data> {
        BodyRequest(parameter, encoder: .none)
    }
}
