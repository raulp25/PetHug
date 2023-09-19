//
//  Dog.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation

struct Dog: Codable, Hashable {
    let id: String
    let name: String
    let age: Int
    let gender: String
    let size: String
    let breed: String
}
