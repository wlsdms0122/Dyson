//
//  ContinuationTests.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import XCTest
@testable import Dyson

final class ContinuationTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() { }
    
    override func tearDown() { }
    
    // MARK: - Test
    func test_that_continuation_success_when_call_with_value() async throws {
        // Given
        let continuation = Continuation<Int> { result in
            switch result {
            case let .success(value):
                XCTAssertEqual(value, 10)
                
            case .failure:
                XCTFail()
            }
        }
        
        // When
        continuation(10)
        
        // Then
    }
    
    func test_that_continuation_fail_when_call_with_error() async throws {
        // Given
        let continuation = Continuation<Int> { result in
            switch result {
            case let .success:
                XCTFail()
                
            case let .failure(error):
                XCTAssertEqual((error as? TestError)?.id, "10")
            }
        }
        
        // When
        continuation(throwing: TestError(id: "10", message: "stop continuration"))
        
        // Then
    }
}
