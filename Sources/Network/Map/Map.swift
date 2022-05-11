//
//  Map.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

// MARK: - Map
public protocol Map {
    associatedtype Value
    
    func map(_ data: Data) throws -> Value
}

// MARK: - Mapper
public struct Mapper<Value>: Map {
    // MARK: - Property
    private let map: (Data) throws -> Value
    
    // MARK: - Initializer
    public init<M: Map>(_ map: M) where M.Value == Value {
        self.map = { try map.map($0) }
    }
    
    public init(_ map: @escaping (Data) throws -> Value) {
        self.map = map
    }
    
    // MARK: - Public
    public func map(_ data: Data) throws -> Value {
        try map(data)
    }
    
    // MARK: - Private
}

public extension Mapper where Value: Decodable {
    static var codable: Self { Mapper(CodableMap<Value>()) }
}

public extension Mapper {
    static var none: Self { Mapper(NoneMap()) }
}
