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
        let data = try encoder.encode(parameter)
        
        var request = URLRequest(url: url)
        request.httpBody = data
        
        return request
    }
    
    // MARK: - Private
}
