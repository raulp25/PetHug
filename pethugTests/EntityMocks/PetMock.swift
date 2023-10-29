//
//  PetMock.swift
//  pethugTests
//
//  Created by Raul Pena on 28/10/23.
//
import Firebase
import Foundation

@testable import pethug

let petMock: Pet = .init(id: "mockId",
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
                         timestamp: Timestamp(date: Date()),
                         owneruid: "xsne65k-e83-55",
                         likedByUsers: [],
                         likesTimestamps: [])
