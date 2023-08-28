//
//  DysonError.swift
//  
//
//  Created by jsilver on 2022/01/09.
//

import Foundation

public enum DysonError: Error {
    case responserNotRegistered
    case invalidURL
    case failedToParse(Error?)
    case failedToLoadData
    case unknown
}
