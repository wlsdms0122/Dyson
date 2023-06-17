//
//  DataSessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

final public class DataSessionTask: SessionTask {
    // MARK: - Property
    public var state = SessionTaskState()
    
    public let tasks: [any SessionTask] = []
    
    public let requests: [URLRequest]
    public let sessionTasks: [URLSessionTask]
    
    public var progress: Progress
    
    private var progressObservation: NSKeyValueObservation?
    
    // MARK: - Initialzer
    public init(
        request: URLRequest,
        sessionTask: URLSessionTask
    ) {
        self.requests = [request]
        self.sessionTasks = [sessionTask]
        
        self.progress = sessionTask.progress
        
        self.progressObservation = sessionTask.observe(\.progress) { [weak self] task, value in
            self?.progress = value.newValue ?? task.progress
        }
    }
    
    // MARK: - Public
    public func addChild(_ task: SessionTask) {
        assertionFailure("`DataSessionTask` cannot have child session tasks.")
    }
    
    public func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}
