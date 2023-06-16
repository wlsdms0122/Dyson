//
//  Encoder.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

// MARK: - Encoder
public protocol Encode<Value> {
    associatedtype Value
    
    func encode(_ value: Value) throws -> Data
}

public struct Encoder<Value>: Encode {
    // MARK: - Property
    private let encode: any Encode<Value>
    
    // MARK: - Initializer
    public init<E: Encode>(_ encode: E) where E.Value == Value {
        self.encode = encode
    }
    
    // MARK: - Public
    public func encode(_ value: Value) throws -> Data {
        try encode.encode(value)
    }
    
    // MARK: - Private
}

public extension Encoder where Value: Encodable {
    static var codable: Self { Encoder(CodableEncode<Value>()) }
}
