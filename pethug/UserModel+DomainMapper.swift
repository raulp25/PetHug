//
//  User+DomainMapper.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation

extension UserModel: ModelMapper {
        
    func toModel() -> UserModel {
        return UserModel(
            id: id!,
            username: username,
            email: email,
            password: password,
            bio: bio,
            profileImageUrl: profileImageUrl
        )
    }
    
}
