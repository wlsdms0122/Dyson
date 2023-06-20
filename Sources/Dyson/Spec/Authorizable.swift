//
//  Authorizable.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public protocol Authorizable {
    var needsAuth: Bool { get }
}
