//
//  PetEntity+DomainMapper.swift
//  pethugTests
//
//  Created by Raul Pena on 31/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug

class PetEntityMappersTests: XCTestCase {
    
    var petMockCopy: Pet!
    
    override func setUp() {
        petMockCopy = .init(id: "mockId",
                                 name: "Ruti",
                                 gender: .female,
                                 size: .small,
                                 breed: "Dachshund",
                                 imagesUrls: ["https://www.mock-url.com/Storage"],
                                 type: .cat,
                                 age: 5,
                                 activityLevel: 7,
                                 socialLevel: 7,
                                 affectionLevel: 10,
                                 address: .Queretaro,
                                 info: "Cute and lovely dog",
                                 medicalInfo: .init(internalDeworming: true,
                                                    externalDeworming: false,
                                                    microchip: true,
                                                    sterilized: false,
                                                    vaccinated: true),
                                 socialInfo: .init(maleDogFriendly: true,
                                                   femaleDogFriendly: false,
                                                   maleCatFriendly: true,
                                                   femaleCatFriendly: false),
                                 isLiked: false,
                                 timestamp: petMock.timestamp,
                                 owneruid: "xsne65k-e83-55",
                                 likedByUsers: [],
                                 likesTimestamps: [])
    }
    
    override func tearDown() {
        petMockCopy = nil
    }
    
    //MARK: - Domain mapper
    func test_with_domain_mapper() {
        
        let petMockDomain = petMock.toDomain()
        
        let petMockCopyDomain = petMockCopy.toDomain()
        
        XCTAssertEqual(petMockCopyDomain, petMockDomain, "petMockCopyDomain should be equal to petMockDomain")
    }
    
    //MARK: - Dictionary literal mapper
    func test_with_dictionary_literal_mapper() {
        
        let petMockDictionary = petMock.toDictionaryLiteral()
        
        let petMockCopyDictionary = petMockCopy.toDictionaryLiteral()
        
        XCTAssertEqual(petMockDictionary as NSDictionary, petMockDictionary as NSDictionary, "petMockCopyDictionary should be equal to petMockDictionary")
    }
    
    //MARK: - Firebase entity mapper
    func test_with_firebase_entity_mapper() {
        
        let petMockFirebaseEntity = petMock.toFirebaseEntity()
        
        let petMockCopyFirebaseEntity = petMockCopy.toFirebaseEntity()
        
        XCTAssertEqual(petMockCopyFirebaseEntity, petMockFirebaseEntity, "petMockCopyFirebaseEntity should be equal to petMockFirebaseEntity")
    }
}


