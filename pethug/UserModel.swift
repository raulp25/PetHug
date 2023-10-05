//
//  User.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import FirebaseFirestoreSwift
import UIKit

struct UserModel {
    @DocumentID var id: String?
    let username: String
    let email: String
    let password: String
    let bio: String?
    let profileImageUrl: UIImage?
}

