//
//  FirebaseMapper.swift
//  pethug
//
//  Created by Raul Pena on 03/10/23.
//

import Foundation

protocol FirebaseMapper {
    associatedtype FirebaseModel
    func toFirebaseEntity() -> FirebaseModel
}

protocol FirebaseUpdatePetMapper {
    associatedtype FirebaseUpdateModel
    func toFirebaseUpdateEntity() -> FirebaseUpdateModel
}

