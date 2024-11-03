//
//  Mockspec.swift
//
//
//  Created by JSilver on 2023/06/17.
//

import Foundation
import Dyson

struct MockSpec<Parameter, Result, Error: Swift.Error>: Spec {
    // MARK: - Property
    let baseURL: String
    let path: String
    
    let method: HTTPMethod
    let transaction: Transaction
    
    let headers: HTTPHeaders
    let request: Request
    let responser: (any Responser)?
    
    let result: Mapper<Result>
    let error: Mapper<Error>
    
    let parameter: Parameter
    
    // MARK: - Initializer
    init(
        baseURL: String = "http://127.0.0.1:8080",
        path: String = "",
        method: HTTPMethod = .get,
        transaction: Transaction = .data,
        headers: HTTPHeaders = [:],
        request: Request = .none,
        responser: (any Responser)? = nil,
        result: Mapper<Result> = .none,
        error: Mapper<Error> = .none,
        parameter: Parameter = Empty()
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.transaction = transaction
        self.headers = headers
        self.request = request
        self.responser = responser
        self.result = result
        self.error = error
        self.parameter = parameter
    }
}

extension MockSpec: Authorizable {
    var needsAuth: Bool { true }
}
