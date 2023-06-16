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
    var targets: [any Target] { get }
    
    var requests: [URLRequest] { get }
    var request: URLRequest? { get }
    
    var sessionTasks: [URLSessionTask] { get }
    var sessionTask: URLSessionTask? { get }
    
    func cancel()
}

public extension SessionTask {
    var targets: [any Target] { tasks.flatMap(\.targets) }
    
    var requests: [URLRequest] { tasks.flatMap(\.requests) }
    var request: URLRequest? { requests.last }
    
    var sessionTasks: [URLSessionTask] { tasks.flatMap(\.sessionTasks) }
    var sessionTask: URLSessionTask? { sessionTasks.last }
    
    func cancel() {
        tasks.last?.cancel()
    }
}
