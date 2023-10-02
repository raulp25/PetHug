//
//  AddressPopupSearchViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 30/09/23.
//

import UIKit

//MARK: - Types
extension AddressPopupSearch {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int {
        case title
    }
    
    enum Item: Hashable {
        case title(SearchAddress)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}

class SearchAddress: Hashable {
    static func == (lhs: SearchAddress, rhs: SearchAddress) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var address: String
    weak var delegate: SearchAddressDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(address)
       }
    init(address: String) {
        self.address = address
    }
}
