//
//  UserEntity+DomainMapperTests.swift
//  pethugTests
//
//  Created by Raul Pena on 31/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug

class UserntityMappersTests: XCTestCase {
    
    var userMockCopy: User!
    
    override func setUp() {
        userMockCopy = .init(id: "mockId75",
                             username: "mockUsername",
                             email: "mockEmail@gmail.com",
                             bio: nil,
                             profileImageUrl: "https://sanity-cms.trpc/-3234&34")
    }
    
    override func tearDown() {
        userMockCopy = nil
    }
    
    //MARK: - Domain mapper
    func test_with_domain_mapper() {
        
        let userMockDomain = userMock.toDomain()
        
        let userMockCopyDomain = userMockCopy.toDomain()
        
        XCTAssertEqual(userMockCopyDomain, userMockDomain, "userMockCopyDomain should be equal to userMockDomain")
    }
    
    //MARK: - Dictionary literal mapper
    func test_with_dictionary_literal_mapper() {
        
        let userMockDictionary = userMock.toDictionaryLiteral()
        
        let userMockCopyDictionary = userMockCopy.toDictionaryLiteral()
        
        XCTAssertEqual(userMockDictionary as NSDictionary, userMockCopyDictionary as NSDictionary, "userMockDictionary should be equal to userMockCopyDictionary")
    }
}



