//
//  DelegatedSessionTask.swift
//  Dyson
//
//  Created by JSilver on 6/6/25.
//
import Foundation

public protocol DelegatedSessionTask: SessionTask {
    /// The delegate of the session task.
    var delegate: (any SessionTaskDelegate)? { get set }
}
