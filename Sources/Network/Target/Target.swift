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
    var transaction: Transaction { get }
    
    var headers: HTTPHeaders { get }
    
    var request: any Request { get }
    var result: Mapper<Result> { get }
    var error: Mapper<Error> { get }
}

public extension Target {
    var url: URL? {
        if #available(iOS 16.0, *) {
            return URL(string:  baseURL)?.appending(path: path)
        } else {
            return URL(string: baseURL)?.appendingPathComponent(path)
        }
    }
}
