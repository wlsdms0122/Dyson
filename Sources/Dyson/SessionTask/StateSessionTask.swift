//
//  StateSessionTask.swift
//  Dyson
//
//  Created by JSilver on 5/25/25.
//

import Foundation

public protocol StateSessionTask: SessionTask {
    var state: SessionState { get set }
    
    func addChild(_ task: any SessionTask)
}

public extension StateSessionTask {
    func callAsFunction(_ child: () -> any SessionTask) {
        addChild(child())
    }
}
