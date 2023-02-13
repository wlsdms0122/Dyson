//
//  ContainerSessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

open class ContainerSessionTask: TargetSessionTask {
    // MARK: - Property
    public private(set) var tasks: [any SessionTask] = []
    public private(set) var state: [String: Any] = [:]
    
    // MARK: - Initialzer
    public init() { }
    
    // MARK: - Public
    open func setState(_ state: Any, forKey key: String) {
        self.state[key] = state
    }
    
    open func state<T>(forKey key: String, to type: T.Type) -> T? {
        state[key] as? T
    }
    
    open func append(_ task: any SessionTask) {
        tasks.append(task)
    }
    
    // MARK: - Private
}
