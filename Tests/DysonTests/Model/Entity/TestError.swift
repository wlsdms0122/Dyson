//
//  TestError.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import Foundation

struct TestError: Error {
    // MARK: - Property
    let id: String
    let message: String
    
    // MARK: - Initializer
    init(
        id: String = "0",
        message: String
    ) {
        self.id = id
        self.message = message
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
