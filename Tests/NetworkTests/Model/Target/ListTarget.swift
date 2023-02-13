//
//  ListTarget.swift
//  
//
//  Created by JSilver on 2022/10/30.
//

import Foundation
import Network

struct ListTarget: Target {
    // MARK: - Property
    var baseURL: String { "http://127.0.0.1:8080"}
    var path: String { "/list" }
    
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
extension ListTarget {
    struct Parameter {
        
    }
    
    struct Result: Decodable {
        let persons: [Person]
        
        enum CodingKeys: CodingKey {
            case name
            case age
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.persons = try container.decode([Person].self)
        }
    }
    
    struct Person: Decodable {
        let name: String
        let age: Int
    }
}

extension ListTarget: Authorizable {
    var needsAuth: Bool { true }
}
