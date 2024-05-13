//
//  CodableEncoder.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

public struct CodableEncode<Value: Encodable>: Encode {
    // MARK: - Property
    private let config: (JSONEncoder) -> Void
    
    // MARK: - Initalizer
    public init(config: @escaping (JSONEncoder) -> Void = { _ in }) {
        self.config = config
    }
    
    // MARK: - Public
    public func encode(_ value: Value) throws -> Data {
        let encoder = JSONEncoder()
        config(encoder)
        
        return try encoder.encode(value)
    }
    
    // MARK: - Private
}

public extension Encoder where Value: Encodable {
    static func codable(config: @escaping (JSONEncoder) -> Void = { _ in }) -> Self {
        Encoder(CodableEncode(config: config))
    }
}
