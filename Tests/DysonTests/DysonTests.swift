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
            ),
            responser: .default
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
        
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(person)
        
        let sut = Dyson(
            provider: .mock(
                dataTask: { request, completion in
                    completion(.success((data, .http(request, status: 200))))
                }
            ),
            responser: .default
        )
        let spec = MockSpec<Empty, Person, Empty>(
            result: .codable
        )
        
        // When
        let response = try await sut.data(spec)
        
        // Then
        XCTAssertEqual(response, person)
    }
}
