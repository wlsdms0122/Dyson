//
//  DataSessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

open class DataSessionTask: SessionTask {
    // MARK: - Property
    public let tasks: [any SessionTask] = []
    
    public let requests: [URLRequest]
    public let sessionTasks: [URLSessionTask]
    
    // MARK: - Initialzer
    public init(
        request: URLRequest,
        sessionTask: URLSessionTask
    ) {
        self.requests = [request]
        self.sessionTasks = [sessionTask]
    }
    
    // MARK: - Public
    open func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}
