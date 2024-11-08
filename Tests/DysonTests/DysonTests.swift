//
//  DysonTests.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import XCTest
@testable import Dyson

final class DysonTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() { }
    
    override func tearDown() { }
    
    // MARK: - Test
    func test_that_dyson_response_using_spec() async throws {
        // Given
        let data = "dyson".data(using: .utf8)!
        
        let sut = Dyson(
            provider: .mock(
                dataTask: { request, completion in
                    completion(.success((data, .http(request, status: 200))))
                }
            )
        )
        let spec = MockSpec<Empty, Empty, Empty>()
        
        // When
        let (response, _) = try await sut.response(spec)
        
        // Then
        XCTAssertEqual(response, data)
    }
    
    func test_that_dyson_response_data_using_spec() async throws {
        // Given
        let person = Person(name: "dyson")
        let json = """
        {
            "name": "dyson"
        }
        """
        
        let data = json.data(using: .utf8) ?? Data()
        
        let sut = Dyson(
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
        
        // When
        let response = try await sut.data(spec)
        
        // Then
        XCTAssertEqual(response, person)
    }
    
    func test_that_dyson_throw_error_when_spec_does_not_specifiy_responser() async throws {
        // Given
        let json = """
        {
            "name": "dyson"
        }
        """
        
        let data = json.data(using: .utf8) ?? Data()
        
        let sut = Dyson(
            provider: .mock(
                dataTask: { request, completion in
                    completion(.success((data, .http(request, status: 200))))
                }
            )
        )
        let spec = MockSpec<Empty, Person, Empty>(
            result: .codable()
        )
        
        // When
        do {
            try await sut.data(spec)
            XCTFail()
        } catch {
            
        }
    }
}
