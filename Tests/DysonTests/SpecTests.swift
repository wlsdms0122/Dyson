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
        _ = try await request(
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
        _ = try await request(
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
        _ = try await request(
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
        _ = try await request(
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
        _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.httpMethod, "DELETE")
                
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
    
    func test_that_request_method_is_PATCH_as_specified_in_the_spec() async throws {
        // Given
        let sut = MockSpec<Empty, Empty, Empty>(
            method: .patch
        )
        
        // When
        _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.httpMethod, "PATCH")
                
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
        _ = try await request(
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
        _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.url?.query, "name=dyson")
                
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
        _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTAssertEqual(request.httpBody, data)
                
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
    
    func test_that_data_task_performed_from_data_transaction_as_specified_in_the_spec() async throws {
        // Given
        let sut = MockSpec<Empty, Empty, Empty>(
            transaction: .data
        )
        
        // When
        _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                completion(.success((Data(), .http(request, status: 200))))
            },
            uploadTask: { _, _, completion in
                XCTFail()
                completion(.failure(TestError(message: "Wrong function called.")))
            },
            downloadTask: { _, completion in
                XCTFail()
                completion(.failure(TestError(message: "Wrong function called.")))
            }
        )
        
        // Then
    }
    
    func test_that_upload_task_performed_from_upload_transaction_as_specified_in_the_spec() async throws {
        // Given
        let originData = "dyson".data(using: .utf8)!
        let sut = MockSpec<Empty, Empty, Empty>(
            transaction: .upload(originData)
        )
        
        // When
        _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTFail()
                completion(.failure(TestError(message: "Wrong function called.")))
            },
            uploadTask: { request, data, completion in
                XCTAssertEqual(data, originData)
                completion(.success((Data(), .http(request, status: 200))))
            },
            downloadTask: { _, completion in
                XCTFail()
                completion(.failure(TestError(message: "Wrong function called.")))
            }
        )
        
        // Then
    }
    
    func test_that_download_task_performed_from_download_transaction_as_specified_in_the_spec() async throws {
        // Given
        let sut = MockSpec<Empty, Empty, Empty>(
            transaction: .download
        )
        
        // When
        _ = try await request(
            spec: sut,
            dataTask: { request, completion in
                XCTFail()
                completion(.failure(TestError(message: "Wrong function called.")))
            },
            uploadTask: { request, _, completion in
                XCTFail()
                completion(.failure(TestError(message: "Wrong function called.")))
            },
            downloadTask: { request, completion in
                completion(.success((Data(), .http(request, status: 200))))
            }
        )
        
        // Then
    }
}
