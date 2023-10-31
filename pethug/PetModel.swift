//
//  PetModel.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//


import FirebaseFirestoreSwift
import Firebase
import UIKit

//type [[String: Any]] breaks conformance to codable/decodable
struct PetModel: Codable, Equatable {
    @DocumentID var id: String? = UUID().uuidString
    let name: String
    let age: Int
    let gender: String?
    let size: String?
    let breed: String
    let imagesUrls: [String]
    let type: String
    let address: String
    let activityLevel: Int
    let socialLevel: Int
    let affectionLevel: Int
    let medicalInfo: MedicalInfo
    let socialInfo: SocialInfo
    let info: String
    var isLiked: Bool
    var timestamp: Timestamp
    var owneruid: String
    var likedByUsers: [String]
    var likesTimestamps: [LikeTimetamp]
}
