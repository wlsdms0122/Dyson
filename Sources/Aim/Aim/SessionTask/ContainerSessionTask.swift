//
//  ContainerSessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

final public class ContainerSessionTask: SessionTask {
    // MARK: - Property
    public var state: SessionTaskState
    
    public private(set) var tasks: [any SessionTask] = []
    
    // MARK: - Initialzer
    init(state: SessionTaskState? = nil) {
        self.state = state ?? SessionTaskState()
    }
    
    // MARK: - Public
    public func addChild(_ task: any SessionTask) {
        state.merge(task.state)
        task.state = state
        
        tasks.append(task)
    }
    
    // MARK: - Private
}
