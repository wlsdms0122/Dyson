//
//  InterceptorTests.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import XCTest
@testable import Dyson

final class InterceptorTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() { }
    
    override func tearDown() { }
    
    // MARK: - Test
    func test_that_header_interceptor_add_header_field_into_request_on_dyson_response() async throws {
        // Given
        let sut = HeaderInterceptor(key: "Authorization", value: "Bearer dyson-test")
        let dyson = DS(
            provider: .mock(
                dataTask: { request, completion in
                    XCTAssertEqual(
                        request.allHTTPHeaderFields?["Authorization"],
                        "Bearer dyson-test"
                    )
                    
                    completion(.success((Data(), .http(request, status: 200))))
                }
            ),
            interceptors: [sut]
        )
        let spec = MockSpec<Empty, Empty, Empty>()
        
        // When
        let _ = try await dyson.response(spec)
        
        // Then
    }
    
    func test_that_authorization_interceptor_add_authorization_field_into_request_on_dyson_response() async throws {
        // Given
        let sut = AuthorizationInterceptor(token: "Bearer dyson-test")
        let dyson = DS(
            provider: .mock(
                dataTask: { request, completion in
                    XCTAssertEqual(
                        request.allHTTPHeaderFields?["Authorization"],
                        "Bearer dyson-test"
                    )
                    
                    completion(.success((Data(), .http(request, status: 200))))
                }
            ),
            interceptors: [sut]
        )
        let spec = MockSpec<Empty, Empty, Empty>()
        
        // When
        let _ = try await dyson.response(spec)
        
        // Then
    }
    
}
