//
//  FilterOptionsMock.swift
//  pethugTests
//
//  Created by Raul Pena on 28/10/23.
//

import Foundation

@testable import pethug

let filterOptionsMock: FilterOptions = .init(gender: .female,
                                             size: .large,
                                             age: .init(min: 12, max: 20),
                                             address: .Sinaloa)
