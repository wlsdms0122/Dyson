//
//  NetworkError.swift
//  
//
//  Created by jsilver on 2022/01/09.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case failedToParse(Error?)
    case unknown
}
