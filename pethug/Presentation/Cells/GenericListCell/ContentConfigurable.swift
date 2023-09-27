//
//  ContentConfigurable.swift
//  pethug
//
//  Created by Raul Pena on 27/09/23.
//

import UIKit

protocol ContentConfigurable: UIContentConfiguration, Hashable {
    associatedtype T: Hashable
    var viewModel: T? { get set }
    init()
}

extension ContentConfigurable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(viewModel)
    }
}
