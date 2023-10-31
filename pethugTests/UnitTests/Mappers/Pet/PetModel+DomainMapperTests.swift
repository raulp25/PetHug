//
//  PetModel+DomainMapperTests.swift
//  pethugTests
//
//  Created by Raul Pena on 31/10/23.
//


import XCTest
import UIKit
import Combine

@testable import pethug

class PetModelMappersTests: XCTestCase {
    
    var petModelMockCopy: PetModel!
    
    override func setUp() {
        
        petModelMockCopy = .init(name: "Ruti",
                                age: 5,
                                gender: "female",
                                size: "small",
                                breed: "Dachshund",
                                imagesUrls: ["https://www.mock-url.com/Storage"],
                                type: "cat",
                                address: "Queretaro",
                                activityLevel: 7,
                                socialLevel: 7,
                                affectionLevel: 10,
                                medicalInfo:.init(internalDeworming: true,
                                                  externalDeworming: false,
                                                  microchip: true,
                                                  sterilized: false,
                                                  vaccinated: true),
                                socialInfo: .init(maleDogFriendly: true,
                                                 femaleDogFriendly: false,
                                                 maleCatFriendly: true,
                                                 femaleCatFriendly: false),
                                info: "Cute and lovely dog",
                                isLiked: false,
                                 timestamp: petModelMock.timestamp,
                                owneruid: "xsne65k-e83-55",
                                likedByUsers: [],
                                likesTimestamps: [])
    }
    
    override func tearDown() {
        petModelMockCopy = nil
    }
    
    //MARK: - Dictionary literal mapper
    func test_with_dictionary_literal_mapper() {
        
        let petModelMockDictionary = petModelMock.toDictionaryLiteral()
        
        let petModelMockCopyDictionary = petModelMockCopy.toDictionaryLiteral()
        
        XCTAssertEqual(petModelMockDictionary as NSDictionary, petModelMockCopyDictionary as NSDictionary, "petMockCopyDictionary should be equal to petMockDictionary")
    }
    
    //MARK: - Dictionary update mapper
    func test_with_dictionary_update_mapper() {
        
        let petModelMockDictionaryUpdate = petModelMock.toDictionaryUpdate()
        
        let petModelMockCopyDictionaryUpdate = petModelMockCopy.toDictionaryUpdate()
        
        XCTAssertEqual(petModelMockDictionaryUpdate as NSDictionary, petModelMockCopyDictionaryUpdate as NSDictionary, "petModelMockDictionaryUpdate should be equal to petModelMockCopyDictionaryUpdate")
    }
    
    //MARK: - Dictionary liked mapper
    func test_with_dictionary_liked_mapper() {
        
        let petModelMockDictionaryLiked = petModelMock.toDictionaryLiked()
        
        let petModelMockCopyDictionaryLiked = petModelMockCopy.toDictionaryLiked()
        
        XCTAssertEqual(petModelMockDictionaryLiked as NSDictionary, petModelMockCopyDictionaryLiked as NSDictionary, "petModelMockDictionaryLiked should be equal to petModelMockCopyDictionaryLiked")
    }
}
 
