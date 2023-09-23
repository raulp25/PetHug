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
    func registerUser(user: User) async throws
}


// MARK: - Implementation -
final class DefaultUserDataSource: UserDataSource {
    
    private let db = Firestore.firestore()
    // theres no need to return nothing since throwing would indicate that something went wrong
    func registerUser(user: User) async throws {
        let data = user.toObjectLiteral()
        try await db.collection(.getPath(for: .users)).document(user.id).setData(data)
    }
    
}




