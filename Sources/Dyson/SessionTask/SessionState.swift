//
//  SessionState.swift
//
//
//  Created by JSilver on 2023/06/13.
//

import Foundation

final public class SessionState: @unchecked Sendable {
    // MARK: - Property
    private var state: [String: Any]
    
    // MARK: - Initializer
    public init(_ state: [String: Any] = [:]) {
        self.state = state
    }
    
    // MARK: - Public
    public subscript(_ key: String) -> Any? {
        get {
            state[key]
        }
        set {
            state[key] = newValue
        }
    }
    
    public subscript<T>(_ key: String, to type: T.Type = T.self) -> T? {
        state[key] as? T
    }
    
    public func merge(_ state: SessionState) {
        self.state.merge(state.state) { _, new in new }
    }
    
    // MARK: - Private
}
