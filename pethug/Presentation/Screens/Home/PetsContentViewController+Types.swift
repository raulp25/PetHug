//
//  PetsContentViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation

//MARK: - Types
extension PetsContentViewController {
    enum Section: Int, CaseIterable, Hashable {
        case dogs
    }
    
    enum Item: Hashable {
        case dogs(Dog)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}
