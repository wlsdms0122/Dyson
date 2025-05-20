//
//  NeverMap.swift
//  Dyson
//
//  Created by JSilver on 5/20/25.
//

import Foundation

public struct NeverMap<Value>: Map {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Public
    public func map(_ data: Data) throws -> Value {
        throw DysonError.intentionalFailure(reason: "NeverMap always fail to map.")
    }
    
    // MARK: - Private
}

public extension Mapper {
    static var never: Self { Mapper(NeverMap()) }
}
