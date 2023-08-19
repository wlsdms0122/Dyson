//
//  NoneMap.swift
//  
//
//  Created by jsilver on 2022/01/25.
//

import Foundation

public struct NoneMap<Value>: Map {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Public
    public func map(_ data: Data) throws -> Value {
        throw DysonError.failedToParse(nil)
    }
    
    // MARK: - Private
}
