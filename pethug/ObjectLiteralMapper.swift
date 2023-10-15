//
//  ObjectLiterlMapper.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation
protocol ObjectLiteralMapper {
    associatedtype ObjectLiteral
    func toObjectLiteral() -> ObjectLiteral
}

protocol ObjectLiteralUpdateMapper {
    associatedtype ObjectLiteralUpdate
    func toObjectLiteralUpdate() -> ObjectLiteralUpdate
}

protocol ObjectLiteralLikedMapper {
    associatedtype ObjectLiteralLiked
    func toObjectLiteralLiked() -> ObjectLiteralLiked
}
