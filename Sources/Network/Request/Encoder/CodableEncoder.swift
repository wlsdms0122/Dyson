//
//  CodableEncoder.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

public struct CodableEncode<Value: Encodable>: Encode {
    // MARK: - Property
    
    // MARK: - Initalizer
    
    // MARK: - Public
    public func encode(_ value: Value) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(value)
    }
    
    // MARK: - Private
}
