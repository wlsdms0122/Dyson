//
//  RequestTests.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import Foundation
import Testing
@testable import Dyson

@Suite("Request Tests")
struct RequestTests {
    @Test
    func none_request_applies_nothing_to_request() async throws {
        let sut: any Request = .none
        
        let originRequest = try URLRequest(url: #require(URL(string: "http://127.0.0.1:8080")))
        var request = originRequest
        
        try sut.apply(to: &request)
        
        #expect(request == originRequest)
    }
    
    @Test
    func query_request_applies_query_to_request() async throws {
        let sut: any Request = .query([
            "name": ["dyson", "wlsdms0122"],
            "age": 30,
            "isAdmin": true,
            "nickname": "jsilver"
        ])
        
        var request = try URLRequest(url: #require(URL(string: "http://127.0.0.1:8080")))

        try sut.apply(to: &request)
        
        #expect(
            Set(request.url?.query?.split(separator: "&") ?? []) == [
                "name=dyson",
                "name=wlsdms0122",
                "age=30",
                "isAdmin=true",
                "nickname=jsilver"
            ]
        )
    }
    
    @Test
    func body_request_applies_data_body_to_request() async throws {
        let data = "dyson".data(using: .utf8)!
        let sut: any Request = .body(data)
        
        var request = try URLRequest(url: #require(URL(string: "http://127.0.0.1:8080")))
        
        try sut.apply(to: &request)
        
        #expect(request.httpBody == data)
    }
    
    @Test
    func body_request_applies_codable_object_body_to_request() async throws {
        let person = Person(name: "dyson")
        
        let sut: any Request = .body(person, encoder: .codable())
        
        var request = try URLRequest(url: #require(URL(string: "http://127.0.0.1:8080")))
        
        try sut.apply(to: &request)
        
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(person)
        
        #expect(request.httpBody == data)
    }
    
    @Test
    func combined_query_and_body_request_applies_both() async throws {
        let query: [String: Any] = [
            "name": ["dyson", "wlsdms0122"],
            "age": 30,
            "isAdmin": true,
            "nickname": "jsilver"
        ]
        let data = "dyson".data(using: .utf8)!
        let sut: any Request = .query(query).combine(with: .body(data))
        
        var request = try URLRequest(url: #require(URL(string: "http://127.0.0.1:8080")))
        try sut.apply(to: &request)
        
        #expect(
            Set(request.url?.query?.split(separator: "&") ?? []) == [
                "name=dyson",
                "name=wlsdms0122",
                "age=30",
                "isAdmin=true",
                "nickname=jsilver"
            ]
        )
        #expect(request.httpBody == data)
    }
}
