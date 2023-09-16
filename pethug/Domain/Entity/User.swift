//
//  User.swift
//  pethug
//
//  Created by Raul Pena on 12/09/23.
//

import Foundation


struct User: Codable {
    let id: String
    let username: String
    let email: String
    let bio: String?
    let profileImageUrl: String?
//    var isCurrentUser: Bool?
}
