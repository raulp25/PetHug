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
            gender: gender,
            size: size,
            breed: breed,
            imagesUrls: imagesUrls,
            type: type,
            age: age,
            activityLevel: activityLevel,
            socialLevel: socialLevel,
            affectionLevel: affectionLevel,
            address: address,
            info: info,
            medicalInfo: medicalInfo,
            socialInfo: socialInfo,
            isLiked: isLiked,
            timestamp: timestamp,
            owneruid: owneruid,
            likedByUsers: likedByUsers
        )
    }
}

extension Pet: ObjectLiteralMapper {
    func toObjectLiteral() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "gender": gender,
            "size": size,
            "breed": breed,
            "imagesUrls": imagesUrls,
            "type": type,
            "age": age,
            "activityLevel": activityLevel,
            "socialLevel": socialLevel,
            "affectionLevel": affectionLevel,
            "medicalInfo": medicalInfo,
            "socialInfo": socialInfo,
            "address": address,
            "info": info,
            "isLiked": isLiked,
            "timestamp": timestamp,
            "owneruid": owneruid,
            "likedByUsers": likedByUsers
        ]
    }
}

extension Pet: FirebaseMapper {
    typealias FirebaseModel = PetModel
    
    func toFirebaseEntity() -> PetModel {
        return PetModel(
            id: id,
            name: name,
            age: age,
            gender: gender?.rawValue,
            size: size?.rawValue,
            breed: breed,
            imagesUrls: imagesUrls,
            type: type.rawValue,
            address: address.rawValue,
            activityLevel: activityLevel,
            socialLevel: socialLevel,
            affectionLevel: affectionLevel,
            medicalInfo: medicalInfo,
            socialInfo: socialInfo,
            info: info,
            isLiked: false,
            timestamp: timestamp,
            owneruid: owneruid,
            likedByUsers: likedByUsers
        )
    }
}

extension PetModel: ObjectLiteralMapper {
    func toObjectLiteral() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "gender": gender,
            "size": size,
            "breed": breed,
            "imagesUrls": imagesUrls,
            "type": type,
            "age": age,
            "activityLevel": activityLevel,
            "socialLevel": socialLevel,
            "affectionLevel": affectionLevel,
            "medicalInfo": medicalInfo.toObjectLiteral(),
            "socialInfo": socialInfo.toObjectLiteral(),
            "address": address,
            "info": info,
            "isLiked": isLiked,
            "timestamp": timestamp,
            "owneruid": owneruid,
            "likedByUsers": likedByUsers
        ]
    }
}

extension PetModel: ObjectLiteralUpdateMapper {
    func toObjectLiteralUpdate() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "gender": gender,
            "size": size,
            "breed": breed,
            "imagesUrls": imagesUrls,
            "type": type,
            "age": age,
            "activityLevel": activityLevel,
            "socialLevel": socialLevel,
            "affectionLevel": affectionLevel,
            "medicalInfo": medicalInfo.toObjectLiteral(),
            "socialInfo": socialInfo.toObjectLiteral(),
            "address": address,
            "info": info
        ]
    }
}

extension PetModel: ObjectLiteralLikedMapper {
    func toObjectLiteralLiked() -> [String: Any] {
        return [
            "likedByUsers": likedByUsers
        ]
    }
}



