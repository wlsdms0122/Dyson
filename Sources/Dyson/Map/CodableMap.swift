//
//  CodableMap.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

public struct CodableMap<Value: Decodable>: Map {
    // MARK: - Property
    private let config: (JSONDecoder) -> Void
    
    // MARK: - Initializer
    public init(config: @escaping (JSONDecoder) -> Void = { _ in }) {
        self.config = config
    }
    
    // MARK: - Public
    public func map(_ data: Data) throws -> Value {
        let decoder = JSONDecoder()
        config(decoder)
        
        do {
            return try decoder.decode(Value.self, from: data)
        } catch {
            throw DysonError.failedToParse(error)
        }
    }
    
    // MARK: - Private
}

public extension Mapper where Value: Decodable {
    static func codable(config: @escaping (JSONDecoder) -> Void = { _ in }) -> Self {
        Mapper(CodableMap<Value>(config: config))
    }
}
