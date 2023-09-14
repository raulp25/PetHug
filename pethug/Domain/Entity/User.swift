//
//  User.swift
//  pethug
//
//  Created by Raul Pena on 12/09/23.
//

import Foundation


struct User: Identifiable {
    let id: Int
    let username: String
    let email: String
    let bio: String?
    let profileImageUrl: String
    
//    var isCurrentUser: Bool?
}
