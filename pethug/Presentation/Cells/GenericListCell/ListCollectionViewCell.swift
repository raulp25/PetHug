//
//  ListCollectionViewCell.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

class ListCollectionViewCell<ContentConfiguration: ContentConfigurable>: UICollectionViewListCell {
    var viewModel: ContentConfiguration.T?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = ContentConfiguration().updated(for: state)
        newConfiguration.viewModel = viewModel
        contentConfiguration = newConfiguration
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
    }
    
    deinit {
        viewModel = nil
    }
}
