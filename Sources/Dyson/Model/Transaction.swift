//
//  RequestType.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public enum Transaction: Sendable {
    case data
    case upload(Data)
    case download
}
