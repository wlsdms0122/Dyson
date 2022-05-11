//
//  Target.swift
//  
//
//  Created by jsilver on 2022/01/09.
//

import Foundation

public protocol Target {
    associatedtype Parameter
    associatedtype Result
    associatedtype Error: Swift.Error
    
    var parameter: Parameter { get }
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    
    var headers: HTTPHeaders { get }
    
    var request: Request { get }
    var result: Mapper<Result> { get }
    var error: Mapper<Error> { get }
}

public extension Target {
    var url: String { baseURL + path }
}
