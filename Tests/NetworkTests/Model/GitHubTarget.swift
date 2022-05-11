//
//  GitHubTarget.swift
//  
//
//  Created by jsilver on 2022/01/25.
//

import Foundation
import Network

struct GitHubTarget: Target {
    let parameter: Parameter
    
    init(_ parameter: Parameter) {
        self.parameter = parameter
    }
    
    var baseURL: String { "https://api.github.com"}
    var path: String { "/users/\(parameter.id)" }
    
    var method: HTTPMethod { .get }
    var task: Task { .data }
    var headers: HTTPHeaders { ["Accept": "application/vnd.github.v3+json"] }
    
    var request: Request { .none }
    var result: Mapper<Result> { .codable }
    var error: Mapper<Error> { .none }
}

extension GitHubTarget {
    struct Parameter {
        let id: String
    }
    
    struct Result: Decodable, Equatable {
        let login: String
        let id: Int
        let name: String
    }
    
    struct Error: Swift.Error {
        
    }
}
