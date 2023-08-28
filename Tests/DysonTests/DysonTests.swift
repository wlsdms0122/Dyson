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
    
    func test_that_dyson_throw_error_when_response_data_without_responser() async throws {
        // Give
        let person = Person(name: "dyson")
        
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(person)
        
        let sut = Dyson(
            provider: .mock(
                dataTask: { request, completion in
                    completion(.success((data, .http(request, status: 200))))
                }
            )
        )
        let spec = MockSpec<Empty, Person, Empty>(
            result: .codable
        )
        
        // When
        do {
            try await sut.data(spec)
            XCTFail()
        } catch {
            
        }
        
        // Then
    }
    
    func test_that_dyson_response_data_when_request_with_responser_even_if_responser_not_registered() async throws {
        // Give
        let person = Person(name: "dyson")
        
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(person)
        
        let sut = Dyson(
            provider: .mock(
                dataTask: { request, completion in
                    completion(.success((data, .http(request, status: 200))))
                }
            )
        )
        let spec = MockSpec<Empty, Person, Empty>(
            result: .codable
        )
        
        // When
        try await sut.data(spec, responser: .default)
        
        // Then
    }
    
    func test_that_dyson_throw_error_when_response_data_even_if_responser_registered() async throws {
        // Give
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
        do {
            try await sut.data(spec, responser: .error(TestError(message: "error")))
            XCTFail()
        } catch {
            
        }
        
        // Then
    }
}
