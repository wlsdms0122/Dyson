//
//  AuthRefreshTarget.swift
//  
//
//  Created by JSilver on 2022/10/30.
//

import Foundation
import Network

struct AuthRefreshTarget: Target {
    // MARK: - Property
    var baseURL: String { "http://127.0.0.1:8080"}
    var path: String { "/auth/refresh" }
    
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

// MARK: - DTO
extension AuthRefreshTarget {
    struct Parameter {
        
    }
    
    struct Result: Decodable {
        let accessToken: String
    }
}
