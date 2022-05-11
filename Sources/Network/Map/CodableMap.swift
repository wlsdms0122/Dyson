//
//  CodableMap.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

public struct CodableMap<Value: Decodable>: Map {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() {
        
    }
    
    // MARK: - Public
    public func map(_ data: Data) throws -> Value {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(Value.self, from: data)
        } catch {
            throw NetworkError.failedToParse(error)
        }
    }
    
    // MARK: - Private
}
