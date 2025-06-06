//
//  SessionTask.swift
//
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

public protocol SessionTask: AnyObject {
    /// The request associated with the session task.
    var request: URLRequest? { get }
    /// The progress that reports the progress of the session task.
    var progress: Progress? { get }
    
    /// Cancel the session task.
    func cancel()
}
