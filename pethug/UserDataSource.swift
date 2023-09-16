//
//  UserDataSource.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation
import FirebaseFirestore

// MARK: - Protocol -
protocol UserDataSource {
    func registerUser(user: User) async throws ->  Result<Bool, Error>
}


// MARK: - Implementation -
final class DefaultUserDataSource: UserDataSource {
    
    private let db = Firestore.firestore()
    
    
    func registerUser(user: User) async throws -> Result<Bool, Error> {
        let data = user.toDomainObject()
        try await FB_COLLECTION_USERS.document(user.id).setData(data)
        return .success(true)
        
    }
    
}




