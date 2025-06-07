//
//  DysonTests.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import Foundation
import Testing
@testable import Dyson

@Suite("Dyson Tests")
struct DysonTests {
    @Test
    func dyson_response_using_spec() async throws {
        let data = "dyson".data(using: .utf8)!
        
        let sut = DS(
            provider: .mock(
                dataTask: { request, completion in
                    completion(.success((data, .http(request, status: 200))))
                }
            )
        )
        let spec = MockSpec<Empty, Empty, Empty>()
        
        let (response, _) = try await sut.response(spec)
        
        #expect(response == data)
    }
    
    @Test
    func dyson_response_data_using_spec() async throws {
        let person = Person(name: "dyson")
        let json = """
        {
            "name": "dyson"
        }
        """
        
        let data = json.data(using: .utf8) ?? Data()
        
        let sut = DS(
            provider: .mock(
                dataTask: { request, completion in
                    completion(.success((data, .http(request, status: 200))))
                }
            )
        )
        let spec = MockSpec<Empty, Person, Empty>(
            responser: .default,
            result: .codable()
        )
        
        let response = try await sut.data(spec)
        
        #expect(response == person)
    }
    
    @Test
    func dyson_throw_error_when_spec_does_not_specifiy_responser() async throws {
        let json = """
        {
            "name": "dyson"
        }
        """
        
        let data = json.data(using: .utf8) ?? Data()
        
        let sut = DS(
            provider: .mock(
                dataTask: { request, completion in
                    completion(.success((data, .http(request, status: 200))))
                }
            )
        )
        let spec = MockSpec<Empty, Person, Empty>(
            result: .codable()
        )
        
        await #expect(throws: (any Error).self) {
            try await sut.data(spec)
        }
    }
}
