//
//  RequestTests.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import XCTest
@testable import Dyson

final class RequestTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() { }
    
    override func tearDown() { }
    
    // MARK: - Test
    func test_that_none_request_make_URLRequest_from_the_url() async throws {
        // Given
        let sut: any Request = .none
        
        // When
        let request = try sut(url: URL(string: "http://127.0.0.1:8080")!)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:8080")
    }
    
    func test_that_query_request_make_URLRequest_from_the_url_with_query() async throws {
        // Given
        let sut: any Request = .query(["name": "dyson"])
        
        // When
        let request = try sut(url: URL(string: "http://127.0.0.1:8080")!)
        
        // Then
        XCTAssertEqual(request.url?.query, "name=dyson")
    }
    
    func test_that_body_request_make_URLRequest_from_the_url_with_data() async throws {
        // Given
        let data = "dyson".data(using: .utf8)!
        let sut: any Request = .body(data)
        
        // When
        let request = try sut(url: URL(string: "http://127.0.0.1:8080")!)
        
        // Then
        XCTAssertEqual(request.httpBody, data)
    }
    
    func test_that_body_request_make_URLRequest_from_the_url_with_encodable_data() async throws {
        // Given
        let person = Person(name: "dyson")
        let sut: any Request = .body(person, encoder: .codable)
        
        // When
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(person)
        
        let request = try sut(url: URL(string: "http://127.0.0.1:8080")!)
        
        // Then
        XCTAssertEqual(request.httpBody, data)
    }
}
