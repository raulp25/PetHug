//
//  String+Extensions.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import UIKit

// MARK: - Predicates
extension String {
    func hasUppecaseCharacters() -> Bool {
        return stringFulfillsRegex(regex: ".*[A-Z]+.*")
    }

    func hasLowercaseCharacters() -> Bool {
        return stringFulfillsRegex(regex: ".*[a-z].*")
    }

    func hasNumbers() -> Bool {
        return stringFulfillsRegex(regex: ".*[0-9].*")
    }

    func hasSpecialCharacters() -> Bool {
        return stringFulfillsRegex(regex: ".*[^A-Za-z0-9].*")
    }

    func isValidEmail() -> Bool {
        return stringFulfillsRegex(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }

    func isPhoneNumValid() -> Bool {
        return stringFulfillsRegex(regex: "^[0-9+]{0,1}+[0-9]{5,16}$")
    }

    private func stringFulfillsRegex(regex: String) -> Bool {
        let texttest = NSPredicate(format: "SELF MATCHES %@", regex)
        guard texttest.evaluate(with: self) else {
            return false
        }
        return true
    }
}

//MARK: - Factory for Firebase collection path
extension String {
    enum CollectionPath: String {
        case users
        case dogs
        case cats
        case rabbits
        case birds
    }
    
    enum StoragePaths: String {
        
        case userProfile = "/profile_images/"
        case petProfile = "/petProfile_images/"
    }
    
    static func getPath(for path: CollectionPath) -> String {
        switch path {
        case .users, .dogs, .cats, .rabbits, .birds:
            return path.rawValue
        }
    }
    
    static func getStoragePath(for path: StoragePaths) -> String {
        switch path {
        case .userProfile, .petProfile:
            return path.rawValue
        }
    }
}
