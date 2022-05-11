//
//  NetworkError.swift
//  
//
//  Created by jsilver on 2022/01/09.
//

import Foundation

public enum NetworkError: Error {
    case notRegisteredResponser
    case invalidURL(String)
    case emptyResponse
    case invalidStatusCode(Int)
    case emptyData
    case failedToParse(Error?)
    case unknown
}
