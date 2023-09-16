//
//  ToModelMapper.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import Foundation


protocol ModelMapper {
    associatedtype UsermodelType

    func toModel() -> UsermodelType
}
