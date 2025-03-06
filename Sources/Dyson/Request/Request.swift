//
//  Request.swift
//  
//
//  Created by jsilver on 2022/01/16.
//

import Foundation

// MARK: - Request
public protocol Request {
    func apply(to request: inout URLRequest) throws
}

public extension Request {
    func combine(with request: any Request) -> any Request {
        Requests._CombineRequest(self, request)
    }
}
