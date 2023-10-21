//
//  UserDataSource.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - Protocol -
protocol UserDataSource {
    func registerUser(user: User) async throws
    func fetchUser() async throws -> User
    func updateUser(imageUrl: String) async throws
}


// MARK: - Implementation -
final class DefaultUserDataSource: UserDataSource {
    
    private let db = Firestore.firestore()
    // theres no need to return nothing since throwing would indicate that something went wrong
    func registerUser(user: User) async throws {
        let data = user.toDictionaryLiteral()
        try await db.collection(.getPath(for: .users)).document(user.id).setData(data)
    }
    
    func fetchUser() async throws -> User {
        let uid = AuthService().uid
        let snapshot = try await db.collection(.getPath(for: .users)).document(uid).getDocument()
        
        let doc = try snapshot.data(as: User.self)
        
        return doc
    }
    
    func updateUser(imageUrl: String) async throws {
        let uid = AuthService().uid
        let dataModel =  ["profileImageUrl": imageUrl]
        
        try await db.collection(.getPath(for: .users))
                    .document(uid)
                    .updateData(dataModel)
    }
    
}




