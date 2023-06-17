//
//  SessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

public protocol SessionTask: AnyObject {
    var state: SessionTaskState { get set }
    
    var tasks: [any SessionTask] { get }
    var specs: [any Spec] { get }
    
    var requests: [URLRequest] { get }
    var request: URLRequest? { get }
    
    var sessionTasks: [URLSessionTask] { get }
    var sessionTask: URLSessionTask? { get }
    
    func addChild(_ task: any SessionTask)
    func cancel()
}

public extension SessionTask {
    var specs: [any Spec] { tasks.flatMap(\.specs) }
    
    var requests: [URLRequest] { tasks.flatMap(\.requests) }
    var request: URLRequest? { requests.last }
    
    var sessionTasks: [URLSessionTask] { tasks.flatMap(\.sessionTasks) }
    var sessionTask: URLSessionTask? { sessionTasks.last }
    
    func cancel() {
        tasks.last?.cancel()
    }
}

public extension SessionTask {
    func callAsFunction(_ child: () -> any SessionTask) {
        addChild(child())
    }
}
