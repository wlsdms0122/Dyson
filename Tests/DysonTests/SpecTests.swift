//
//  SpecTests.swift
//
//
//  Created by jsilver on 2021/06/06.
//

import XCTest
@testable import Dyson

final class SpecTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() { }
    
    override func tearDown() { }
    
    // MARK: - Test
    func test_that_request_url_is_combination_of_baseURL_and_path_as_specified_in_the_spec() async throws {
        // Given
        let sut = MockSpec<Empty, Empty, Empty>(
            baseURL: "http://127.0.0.1:8080",
            path: "ping"
        )
        
        // When
        let _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:8080/ping")
                
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
    
    func test_that_request_method_is_GET_as_specified_in_the_spec() async throws {
        // Given
        let sut = MockSpec<Empty, Empty, Empty>(
            method: .get
        )
        
        // When
        let _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.httpMethod, "GET")
                
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
    
    func test_that_request_method_is_POST_as_specified_in_the_spec() async throws {
        // Given
        let sut = MockSpec<Empty, Empty, Empty>(
            method: .post
        )
        
        // When
        let _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.httpMethod, "POST")
                
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
    
    func test_that_request_method_is_PUT_as_specified_in_the_spec() async throws {
        // Given
        let sut = MockSpec<Empty, Empty, Empty>(
            method: .put
        )
        
        // When
        let _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.httpMethod, "PUT")
                
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
    
    func test_that_request_method_is_DELETE_as_specified_in_the_spec() async throws {
        // Given
        let sut = MockSpec<Empty, Empty, Empty>(
            method: .delete
        )
        
        // When
        let _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.httpMethod, "DELETE")
                
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
    
    func test_that_request_header_contains_authorization_as_specified_in_the_spec() async throws {
        // Given
        let sut = MockSpec<Empty, Empty, Empty>(
            headers: ["Authorization": "Bearer dyson-spec-tests"]
        )
        
        // When
        let _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(
                    request.allHTTPHeaderFields?["Authorization"],
                    "Bearer dyson-spec-tests"
                )
                
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
    
    func test_that_request_url_has_queries_as_specified_in_the_spec() async throws {
        // Given
        let sut = MockSpec<Empty, Empty, Empty>(
            request: .query(["name": "dyson"])
        )
        
        // When
        let _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.url?.query(), "name=dyson")
                
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
    
    func test_that_request_has_body_from_data_as_specified_in_the_spec() async throws {
        // Given
        let data = "dyson".data(using: .utf8)!
        let sut = MockSpec<Empty, Empty, Empty>(
            request: .body(data)
        )
        
        // When
        let _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.httpBody, data)
                
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
}
