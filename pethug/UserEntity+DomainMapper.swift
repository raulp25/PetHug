//
//  UserEntity+DomainMapper.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation




extension User: DomainMapper {
    func toDomain() -> User {
        return User(
            id: id,
            username: username,
            email: email,
            bio: bio,
            profileImageUrl: profileImageUrl
        )
    }
}

extension User: ObjectLiteralMapper {
    func toObjectLiteral() -> [String: Any] {
        return [
            "id": id,
            "username": username,
            "email": email,
            "bio": bio,
            "profileImageUrl": profileImageUrl
        ]
    }
}
