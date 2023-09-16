//
//  DomainMapperProtocol.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation

protocol DomainMapper {
    associatedtype EntityType
    func toDomain() -> EntityType
}
