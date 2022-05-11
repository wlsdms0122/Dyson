//
//  Encoder.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

// MARK: - Encoder
public protocol Encode {
    associatedtype Value
    
    func encode(_ value: Value) throws -> Data
}

public struct Encoder<Value>: Encode {
    // MARK: - Property
    private let encode: (Value) throws -> Data
    
    // MARK: - Initializer
    public init<E: Encode>(_ encode: E) where E.Value == Value {
        self.encode = { try encode.encode($0) }
    }
    
    public init(_ encode: @escaping (Value) throws -> Data) {
        self.encode = encode
    }
    
    // MARK: - Public
    public func encode(_ value: Value) throws -> Data {
        try encode(value)
    }
    
    // MARK: - Private
}

// MARK: - CodableEncoder
public extension Encoder where Value: Encodable {
    static var codable: Self { Encoder(CodableEncode<Value>()) }
}
