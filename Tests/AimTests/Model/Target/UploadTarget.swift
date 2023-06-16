//
//  UploadTarget.swift
//  
//
//  Created by jsilver on 2022/07/07.
//

import Foundation
import Aim

struct UploadTarget: Target {
    // MARK: - Property
    var baseURL: String { "http://127.0.0.1:8080"}
    var path: String { "/static/upload" }
    
    var method: HTTPMethod { .post }
    var transaction: Transaction { .upload(parameter.data) }
    
    var headers: HTTPHeaders { [:] }
    var request: Request { .none }
    
    var result: Mapper<Result> { .codable }
    var error: Mapper<NTError> { .codable }
    
    let parameter: Parameter
    
    // MARK: - Initializer
    init(_ parameter: Parameter) {
        self.parameter = parameter
    }
}

// MARK: - DTO
extension UploadTarget {
    struct Parameter: Encodable {
        let data: Data
    }
    
    struct Result: Decodable, Equatable {
        
    }
}
