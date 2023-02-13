//
//  NTError.swift
//  
//
//  Created by JSilver on 2023/02/13.
//

import Foundation

struct NTError: Error, Decodable {
    let code: String
    let message: String
}
