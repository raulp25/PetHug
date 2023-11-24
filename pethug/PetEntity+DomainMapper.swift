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
            likedByUsers: likedByUsers,
            likesTimestamps: likesTimestamps
        )
    }
}

extension Pet: DictionaryLiteralMapper {
    func toDictionaryLiteral() -> [String: Any] {
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
            "likedByUsers": likedByUsers,
            "likesTimestamps": likesTimestamps
        ]
    }
}

extension Pet: FirebaseMapper {
//    typealias FirebaseModel = PetModel
    
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
            likedByUsers: likedByUsers,
            likesTimestamps: likesTimestamps
        )
    }
}

extension PetModel: DictionaryLiteralMapper {
    func toDictionaryLiteral() -> [String: Any] {
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
            "likedByUsers": likedByUsers,
            "likesTimestamps": likesTimestamps.map({ $0.toObjectLiteral() })
        ]
    }
}

extension PetModel: DictionaryUpdateMapper {
    func toDictionaryUpdate() -> [String: Any] {
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

extension PetModel: DictionaryLikedMapper {
    func toDictionaryLiked() -> [String: Any] {
        return [
            "likedByUsers": likedByUsers,
            "likesTimestamps": likesTimestamps.map({ $0.toObjectLiteral() })
        ]
    }
}



