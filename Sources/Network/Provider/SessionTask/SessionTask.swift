//
//  SessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

public protocol SessionTask: AnyObject {
    var tasks: [any SessionTask] { get }
    
    var requests: [URLRequest] { get }
    var request: URLRequest? { get }
    
    var sessionTasks: [URLSessionTask] { get }
    var sessionTask: URLSessionTask? { get }
    
    func cancel()
}

public extension SessionTask {
    var requests: [URLRequest] { tasks.flatMap(\.requests) }
    var request: URLRequest? { requests.last }
    
    var sessionTasks: [URLSessionTask] { tasks.flatMap(\.sessionTasks) }
    var sessionTask: URLSessionTask? { sessionTasks.last }
    
    func cancel() {
        tasks.last?.cancel()
    }
}

public protocol TargetSessionTask: SessionTask {
    var state: [String: Any] { get }
    
    func setState(_ state: Any, forKey key: String)
    func state<T>(forKey key: String, to type: T.Type) -> T?
    func append(_ task: any SessionTask)
}

public extension TargetSessionTask {
    func state(forKey key: String) -> Any? {
        state(forKey: key, to: Any.self)
    }
}
