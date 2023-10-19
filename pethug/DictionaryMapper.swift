//
//  ObjectLiterlMapper.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation
protocol DictionaryLiteralMapper {
    associatedtype DictionaryLiteral
    func toDictionaryLiteral() -> DictionaryLiteral
}

protocol DictionaryUpdateMapper {
    associatedtype DictionaryUpdate
    func toDictionaryUpdate() -> DictionaryUpdate
}

protocol DictionaryLikedMapper {
    associatedtype DictionaryLiked
    func toDictionaryLiked() -> DictionaryLiked
}
