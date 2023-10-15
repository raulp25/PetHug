//
//  UpdatePetModel.swift
//  pethug
//
//  Created by Raul Pena on 15/10/23.
//

import FirebaseFirestoreSwift
import Firebase
import UIKit

struct UpdatePetModel {
    var id: String
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
    let info: String
}
