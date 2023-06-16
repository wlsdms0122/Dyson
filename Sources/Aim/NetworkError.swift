//
//  NetworkError.swift
//  
//
//  Created by jsilver on 2022/01/09.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case failedToValidate
    case failedToValidateFromStatusCode(Int)
    case failedToParse(Error?)
    case unknown
}
