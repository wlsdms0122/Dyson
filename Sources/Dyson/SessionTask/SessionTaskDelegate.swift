//
//  SessionTaskDelegate.swift
//  Dyson
//
//  Created by JSilver on 5/25/25.
//

import Foundation

public protocol SessionTaskDelegate: AnyObject {
    func sessionTaskDidResume(_ sessionTask: any SessionTask)
    func sessionTask(_ sessionTask: any SessionTask, didSend bytes: Int64, totalBytes: Int64)
    func sessionTaskDidCancel(_ sessionTask: any SessionTask)
    func sessionTaskDidComplete(_ sessionTask: any SessionTask)
}
