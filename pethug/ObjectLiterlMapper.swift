//
//  ObjectLiterlMapper.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation
protocol ObjectLiteralMapper {
    associatedtype ObjectLiteral
    func toDomainObject() -> ObjectLiteral
}
