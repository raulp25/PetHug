//
//  FilterAddressPopupSearchViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 12/10/23.
//

import UIKit

//MARK: - Types
extension FilterAddressPopupSearch {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int {
        case state
    }
    
    enum Item: Hashable {
        case state(FilterSearchAddress)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}

class FilterSearchAddress: Hashable {
    static func == (lhs: FilterSearchAddress, rhs: FilterSearchAddress) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID().uuidString
    var state: FilterState?
    var address: String?
    weak var delegate: FilterSearchAddressDelegate?
    func hash(into hasher: inout Hasher) {
           hasher.combine(address)
       }
    init(address: String) {
        self.address = address
    }
}

