//
//  EncoderTests.swift
//
//
//  Created by JSilver on 2023/06/20.
//

import Foundation
import Testing
@testable import Dyson

@Suite("Encoder Tests")
struct EncoderTests {
    @Test
    func encoder_encode_using_none_encode() async throws {
        let sut: Encoder<Data> = .none
        
        let data = "dyson".data(using: .utf8)!
        
        let encodedData = try sut.encode(data)
        
        #expect(encodedData == data)
    }
    
    @Test
    func encoder_encode_using_codable_encode() async throws {
        let sut: Encoder<Person> = .codable()
        
        let person = Person(name: "dyson")
        
        let encodedData = try sut.encode(person)
        
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(person)
        
        #expect(encodedData == data)
    }
}
