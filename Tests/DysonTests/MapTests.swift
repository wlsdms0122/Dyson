//
//  MapperTests.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import XCTest
@testable import Dyson

final class MapperTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() { }
    
    override func tearDown() { }
    
    // MARK: - Test
    func test_that_none_mapper_fail_to_decoding_always() async throws {
        // Given
        let data = "dyson".data(using: .utf8)!
        let sut: Mapper<Data> = .none
        
        // When
        XCTAssertThrowsError(try sut.map(data))
        
        // Then
    }
    
    func test_that_codable_mapper_succeed_in_decoding_with_decodable_data() async throws {
        // Given
        let person = Person(name: "dyson")
        
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(person)
        
        let sut: Mapper<Person> = .codable()
        
        // When
        let decodedData = try sut.map(data)
        
        // Then
        XCTAssertEqual(decodedData, person)
    }
    
    func test_that_codable_mapper_throw_error_when_fail_to_decoding() async throws {
        // Given
        let coffee = Coffee(bean: "brazil")
        
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(coffee)
        
        let sut: Mapper<Person> = .codable()
        
        // When
        XCTAssertThrowsError(try sut.map(data))
        
        // Then
    }
}
