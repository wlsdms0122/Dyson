//
//  DataSessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

open class DataSessionTask: SessionTask {
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
    open func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}
