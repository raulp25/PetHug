//
//  PetModel.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//


import FirebaseFirestoreSwift
import Firebase
import UIKit


struct PetModel: Codable {
    
    @DocumentID var id: String? = UUID().uuidString
    let name: String
    let age: Int
    let gender: String?
    let size: String?
    let breed: String
    let imagesUrls: [String]
    let type: String
    let address: String
    var isLiked: Bool
    var timestamp: Timestamp
    
    init(
        id: String,
        name: String,
        age: Int,
        gender: String?,
        size: String?,
        breed: String,
        imagesUrls: [String],
        type: String,
        address: String,
        isLiked: Bool,
        timestamp: Timestamp
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.size = size
        self.breed = breed
        self.imagesUrls = imagesUrls
        self.type = type
        self.address = address
        self.isLiked = isLiked
        self.timestamp = timestamp
    }
}
