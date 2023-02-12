//
//  TargetSessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

public class TargetSessionTask: SessionTask {
    // MARK: - Property
    public private(set) var tasks: [any SessionTask] = []
    
    // MARK: - Initialzer
    init() { }
    
    // MARK: - Public
    public func callAsFunction(_ task: () -> any SessionTask) {
        append(task())
    }
    
    public func append(_ task: any SessionTask) {
        tasks.append(task)
    }
    
    // MARK: - Private
}
