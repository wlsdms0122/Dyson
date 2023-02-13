//
//  Map.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

// MARK: - Map
public protocol Map<Value> {
    associatedtype Value
    
    func map(_ data: Data) throws -> Value
}

// MARK: - Mapper
public struct Mapper<Value>: Map {
    // MARK: - Property
    private let map: any Map<Value>
    
    // MARK: - Initializer
    public init<M: Map>(_ map: M) where M.Value == Value {
        self.map = map
    }
    
    // MARK: - Public
    public func map(_ data: Data) throws -> Value {
        try map.map(data)
    }
    
    // MARK: - Private
}

public extension Mapper {
    static var none: Self { Mapper(NoneMap()) }
}

public extension Mapper where Value: Decodable {
    static var codable: Self { Mapper(CodableMap<Value>()) }
}
