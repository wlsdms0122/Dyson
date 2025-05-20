//
//  NoneMap.swift
//  
//
//  Created by jsilver on 2022/01/25.
//

import Foundation

public struct NoneMap: Map {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Public
    public func map(_ data: Data) throws { }
    
    // MARK: - Private
}

public extension Mapper where Value == Void {
    static var none: Self { Mapper(NoneMap()) }
}
