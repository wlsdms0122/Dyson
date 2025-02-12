//
//  Requests.swift
//  Dyson
//
//  Created by jsilver on 2/11/25.
//

import Foundation

enum Requests { }

extension Requests {
    struct _CombineRequest: Request {
        // MARK: - Property
        private let a: any Request
        private let b: any Request
        
        // MARK: - Initializer
        public init(_ a: any Request, _ b: any Request) {
            self.a = a
            self.b = b
        }
        
        // MARK: - Public
        func apply(to request: inout URLRequest) throws {
            try a.apply(to: &request)
            try b.apply(to: &request)
        }
        
        // MARK: - Private
    }
}
