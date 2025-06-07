//
//  InterceptorTests.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import Foundation
import Testing
@testable import Dyson

@Suite("Interceptor Tests")
struct InterceptorTests {
    @Test
    func header_interceptor_add_header_field_into_request() async throws {
        let sut = HeaderInterceptor(key: "Authorization", value: "Bearer dyson-test-token")
        
        let dyson = DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.allHTTPHeaderFields?["Authorization"] == "Bearer dyson-test-token")
                    
                    completion(.success((Data(), .http(request, status: 200))))
                }
            ),
            interceptors: [sut]
        )
        let spec = MockSpec<Empty, Empty, Empty>()
        
        try await dyson.response(spec)
    }
    
    @Test
    func authorization_interceptor_add_authorization_field_into_request() async throws {
        let sut = AuthorizationInterceptor(token: "Bearer dyson-test-token")
        
        let dyson = DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.allHTTPHeaderFields?["Authorization"] == "Bearer dyson-test-token")
                    
                    completion(.success((Data(), .http(request, status: 200))))
                }
            ),
            interceptors: [sut]
        )
        let spec = MockSpec<Empty, Empty, Empty>()
        
        try await dyson.response(spec)
    }
}
