//
//  DataSessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

class DataSessionTask: SessionTask {
    // MARK: - Property
    let tasks: [any SessionTask] = []
    
    let request: URLRequest?
    let sessionTask: URLSessionTask?
    
    // MARK: - Initialzer
    init(
        request: URLRequest,
        sessionTask: URLSessionTask
    ) {
        self.request = request
        self.sessionTask = sessionTask
    }
    
    // MARK: - Public
    func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}
