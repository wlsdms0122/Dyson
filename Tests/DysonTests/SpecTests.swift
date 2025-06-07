//
//  SpecTests.swift
//
//
//  Created by jsilver on 2021/06/06.
//

import Foundation
import Testing
@testable import Dyson

@Suite("Spec Tests")
struct SpecTests {
    @Test
    func request_url_combines_with_base_url_and_path_of_the_spec() async throws {
        let sut = MockSpec<Empty, Empty, Empty>(
            baseURL: "http://127.0.0.1:8080",
            path: "ping"
        )
        
        try await DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.url?.absoluteString == "http://127.0.0.1:8080/ping")
                    completion(.success((Data(), .http(request, status: 200))))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func request_method_is_GET_as_specified_in_the_spec() async throws {
        let sut = MockSpec<Empty, Empty, Empty>(
            method: .get
        )
        
        try await DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.httpMethod == "GET")
                    completion(.success((Data(), .http(request, status: 200))))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func request_method_is_POST_as_specified_in_the_spec() async throws {
        let sut = MockSpec<Empty, Empty, Empty>(
            method: .post
        )
        
        try await DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.httpMethod == "POST")
                    completion(.success((Data(), .http(request, status: 200))))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func request_method_is_PUT_as_specified_in_the_spec() async throws {
        let sut = MockSpec<Empty, Empty, Empty>(
            method: .put
        )
        
        try await DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.httpMethod == "PUT")
                    completion(.success((Data(), .http(request, status: 200))))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func request_method_is_DELETE_as_specified_in_the_spec() async throws {
        let sut = MockSpec<Empty, Empty, Empty>(
            method: .delete
        )
        
        try await DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.httpMethod == "DELETE")
                    completion(.success((Data(), .http(request, status: 200))))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func request_method_is_PATCH_as_specified_in_the_spec() async throws {
        let sut = MockSpec<Empty, Empty, Empty>(
            method: .patch
        )
        
        try await DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.httpMethod == "PATCH")
                    completion(.success((Data(), .http(request, status: 200))))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func request_header_contains_authorization_as_specified_in_the_spec() async throws {
        let sut = MockSpec<Empty, Empty, Empty>(
            headers: ["Authorization": "Bearer dyson-test-token"]
        )
        
        try await DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.allHTTPHeaderFields?["Authorization"] == "Bearer dyson-test-token")
                    completion(.success((Data(), .http(request, status: 200))))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func request_url_has_queries_as_specified_in_the_spec() async throws {
        let sut = MockSpec<Empty, Empty, Empty>(
            request: .query(["name": "dyson"])
        )
        
        try await DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.url?.query == "name=dyson")
                    completion(.success((Data(), .http(request, status: 200))))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func request_has_body_from_data_as_specified_in_the_spec() async throws {
        let data = "dyson".data(using: .utf8)!
        let sut = MockSpec<Empty, Empty, Empty>(
            request: .body(data)
        )
        
        try await DS(
            provider: .mock(
                dataTask: { request, completion in
                    #expect(request.httpBody == data)
                    completion(.success((Data(), .http(request, status: 200))))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func data_task_performed_from_data_transaction_as_specified_in_the_spec() async throws {
        let sut = MockSpec<Empty, Empty, Empty>(
            transaction: .data
        )
        
        try await DS(
            provider: .mock(
                dataTask: { request, completion in
                    completion(.success((Data(), .http(request, status: 200))))
                },
                uploadTask: { _, _, completion in
                    Issue.record("Wrong function called.")
                    completion(.failure(TestError(message: "Wrong function called.")))
                },
                downloadTask: { _, completion in
                    Issue.record("Wrong function called.")
                    completion(.failure(TestError(message: "Wrong function called.")))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func upload_task_performed_from_upload_transaction_as_specified_in_the_spec() async throws {
        let originData = "dyson".data(using: .utf8)!
        let sut = MockSpec<Empty, Empty, Empty>(
            transaction: .upload(originData)
        )
        
        try await DS(
            provider: .mock(
                dataTask: { _, completion in
                    Issue.record("Wrong function called.")
                    completion(.failure(TestError(message: "Wrong function called.")))
                },
                uploadTask: { request, data, completion in
                    #expect(data == originData)
                    completion(.success((data, .http(request, status: 200))))
                },
                downloadTask: { _, completion in
                    Issue.record("Wrong function called.")
                    completion(.failure(TestError(message: "Wrong function called.")))
                }
            )
        )
            .response(sut)
    }
    
    @Test
    func download_task_performed_from_download_transaction_as_specified_in_the_spec() async throws {
        let sut = MockSpec<Empty, Empty, Empty>(
            transaction: .download
        )
        
        try await DS(
            provider: .mock(
                dataTask: { _, completion in
                    Issue.record("Wrong function called.")
                    completion(.failure(TestError(message: "Wrong function called.")))
                },
                uploadTask: { _, _, completion in
                    Issue.record("Wrong function called.")
                    completion(.failure(TestError(message: "Wrong function called.")))
                },
                downloadTask: { request, completion in
                    completion(.success((Data(), .http(request, status: 200))))
                }
            )
        )
            .response(sut)
    }
}
