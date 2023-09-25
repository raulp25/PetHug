//
//  PetEntity+DomainMapper.swift
//  pethug
//
//  Created by Raul Pena on 24/09/23.
//

import Foundation

extension Pet: DomainMapper {
    func toDomain() -> Pet {
        return Pet(
            id: id,
            name: name,
            age: age,
            gender: gender,
            size: size,
            breed: breed,
            imageUrl: imageUrl,
            type: type,
            address: address,
            isLiked: isLiked
        )
    }
}

extension Pet: ObjectLiteralMapper {
    func toObjectLiteral() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "age": age,
            "gender": gender,
            "size": size,
            "breed": breed,
            "imageUrl": imageUrl,
            "type": type
        ]
    }
}
