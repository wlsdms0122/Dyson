//
//  ContinuationTests.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import Testing
@testable import Dyson

@Suite("Continuation Tests")
struct ContinuationTests {
    @Test
    func continuation_resume_with_value() async throws {
        let continuation = Continuation<Int> { result in
            guard case let .success(value) = result else {
                Issue.record("Continuation failed.")
                return
            }
            
            #expect(value == 10)
        }
        
        continuation(10)
    }
    
    @Test
    func continuation_resume_with_error() async throws {
        let continuation = Continuation<Int> { result in
            guard case let .failure(error) = result else {
                Issue.record("Continuation succeed.")
                return
            }
            
            #expect((error as? TestError)?.id == "10")
        }
        
        continuation(throwing: TestError(id: "10", message: "Continuation failed."))
    }
}
