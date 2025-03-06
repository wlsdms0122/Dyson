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
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8080")!)
        let sut: any Request = .none
        
        // When
        try sut.apply(to: &request)
        
        // Then
        XCTAssertEqual(request.url?.absoluteString, "http://127.0.0.1:8080")
    }
    
    func test_that_query_request_make_URLRequest_from_the_url_with_query() async throws {
        // Given
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8080")!)
        let sut: any Request = .query([
            "name": ["dyson", "wlsdms0122"],
            "age": 20,
            "isAdmin": true,
            "nickname": "jsilver"
        ])
        
        // When
        try sut.apply(to: &request)
        
        // Then
        
        XCTAssertEqual(
            Set(request.url?.query?.split(separator: "&") ?? []),
            [
                "name=dyson",
                "name=wlsdms0122",
                "age=20",
                "isAdmin=true",
                "nickname=jsilver"
            ]
        )
    }
    
    func test_that_body_request_make_URLRequest_from_the_url_with_data() async throws {
        // Given
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8080")!)
        let data = "dyson".data(using: .utf8)!
        let sut: any Request = .body(data)
        
        // When
        try sut.apply(to: &request)
        
        // Then
        XCTAssertEqual(request.httpBody, data)
    }
    
    func test_that_body_request_make_URLRequest_from_the_url_with_encodable_data() async throws {
        // Given
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8080")!)
        let person = Person(name: "dyson")
        let sut: any Request = .body(person, encoder: .codable())
        
        // When
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(person)
        
        try sut.apply(to: &request)
        
        // Then
        XCTAssertEqual(request.httpBody, data)
    }
    
    func test_that_query_request_combine_with_body_request_make_URLRequest_from_the_url_with_query_and_data() async throws {
        // Given
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8080")!)
        let query: [String: Any] = [
            "name": ["dyson", "wlsdms0122"],
            "age": 20,
            "isAdmin": true,
            "nickname": "jsilver"
        ]
        let data = "dyson".data(using: .utf8)!
        let sut: any Request = .query(query).combine(with: .body(data))
        
        // When
        try sut.apply(to: &request)
        
        // Then
        XCTAssertEqual(
            Set(request.url?.query?.split(separator: "&") ?? []),
            [
                "name=dyson",
                "name=wlsdms0122",
                "age=20",
                "isAdmin=true",
                "nickname=jsilver"
            ]
        )
        XCTAssertEqual(request.httpBody, data)
    }
}
