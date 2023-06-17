//
//  EmptySessionTask.swift
//
//
//  Created by JSilver on 2023/06/16.
//

import Foundation

public class EmptySessionTask: SessionTask {
    // MARK: - Property
    public var state = SessionTaskState()
    public let tasks: [SessionTask] = []
    
    // MARK: - Initiailzer
    public init() { }
    
    // MARK: - Public
    public func addChild(_ task: SessionTask) {
        assertionFailure("`DataSessionTask` cannot have child session tasks.")
    }
    
    // MARK: - Private
}
