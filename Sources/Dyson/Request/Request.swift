//
//  Request.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

// MARK: - Request
public protocol Request {
    func make(url: URL) throws -> URLRequest
}

public extension Request {
    func callAsFunction(url: URL) throws -> URLRequest {
        try make(url: url)
    }
}
