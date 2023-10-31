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

extension User: DictionaryLiteralMapper {
    func toDictionaryLiteral() -> [String: Any] {
        return [
            "id": id,
            "username": username,
            "email": email,
            "bio": bio,
            "profileImageUrl": profileImageUrl
        ]
    }
}

//   //MARK: - Maybe usefull in the future
//    func dict() throws -> [String: Any] {
//        let data = try JSONEncoder().encode(self)
//        return try castDataToDict(data: data)
//    }
//
//    private func castDataToDict(data: Data) throws -> [String: Any] {
//        guard let dict = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
//            throw URLError(.badURL)
//        }
//        return dict
//    }
//
