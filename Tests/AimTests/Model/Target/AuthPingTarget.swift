//
//  AuthPingTarget.swift
//  
//
//  Created by JSilver on 2022/10/30.
//

import Foundation
import Aim

struct AuthPingTarget: Target {
    // MARK: - Property
    var baseURL: String { "http://127.0.0.1:8080"}
    var path: String { "auth/ping" }
    
    var method: HTTPMethod { .get }
    var transaction: Transaction { .data }
    
    var headers: HTTPHeaders { [:] }
    var request: Request { .none }
    
    var result: Mapper<Result> { .codable }
    var error: Mapper<NTError> { .codable }
    
    let parameter: Parameter
    
    // MARK: - Inititlizer
    init(_ parameter: Parameter) {
        self.parameter = parameter
    }
}

extension AuthPingTarget: Authorizable {
    var needsAuth: Bool { true }
}

// MARK: - DTO
extension AuthPingTarget {
    struct Parameter {
        
    }
    
    struct Result: Decodable {
        let status: String
    }
}
