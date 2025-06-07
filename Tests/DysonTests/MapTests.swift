//
//  MapperTests.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import Foundation
import Testing
@testable import Dyson

@Suite("Mapper Tests")
struct MapperTests {
    @Test
    func never_mapper_always_fail_to_decode() async throws {
        let sut: Mapper<Data> = .never
        
        let data = "dyson".data(using: .utf8)!
        
        #expect(throws: (any Error).self) {
            try sut.map(data)
        }
    }
    
    @Test
    func none_mapper_always_success_to_decode() async throws {
        let sut: Mapper<Void> = .none

        let data = "dyson".data(using: .utf8)!
                
        #expect(throws: Never.self) {
            try sut.map(data)
        }
    }
    
    @Test
    func codable_mapper_succeed_in_decoding_with_decodable_data() async throws {
        let sut: Mapper<Person> = .codable()
        
        let person = Person(name: "dyson")
        
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(person)
        
        let decodedData = try sut.map(data)
        
        #expect(decodedData == person)
    }
    
    @Test
    func codable_mapper_throw_error_when_fail_to_decode() async throws {
        let coffee = Coffee(bean: "brazil")
        
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(coffee)
        
        let sut: Mapper<Person> = .codable()
        
        #expect(throws: (any Error).self) {
            try sut.map(data)
        }
    }
}
