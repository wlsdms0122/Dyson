//
//  NoneRequest.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public struct NoneRequest: Request {
    // MARK: - Property
    
    // MARK: - Initializer
    
    // MARK: - Public
    public func apply(to request: inout URLRequest) throws { }
    
    // MARK: - Private
}

public extension Request where Self == NoneRequest {
    static var none: Self { NoneRequest() }
}
