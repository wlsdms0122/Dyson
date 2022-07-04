//
//  HTTPMethod.swift
//  
//
//  Created by jsilver on 2022/01/14.
//

import Foundation

public struct HTTPMethod: Equatable {
    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let delete = HTTPMethod(rawValue: "DELETE")
    
    // MARK: - Property
    public let rawValue: String
    
    // MARK: - Initiailzer
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
