//
//  FilterPetsViewModelFailureTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug


class FilterPetsViewModelFailureTests: XCTestCase {
    private var vm: FilterPetsViewModel!
    private var isValidFormSpy: ValidValueSpy!
    
    private func resetUserDefaultsKeys() {
        for key in FilterKeys.allCases {
            UserDefaults.standard.removeObject(forKey: key.rawValue) //Remove Filter screen options
        }
    }
    
    override func setUp() {
        resetUserDefaultsKeys()
        
        vm = FilterPetsViewModel()
        isValidFormSpy = ValidValueSpy(vm.isValidSubject.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        vm = nil
        isValidFormSpy = nil
    }
    
    //MARK: - From validation
    
    func test_with_formValidation_result_is_false() {
        
        defer {
            XCTAssertFalse(isValidFormSpy.value, "The published value should be false")
        }
        
        vm.genderState    = .all
        vm.sizeState      = .all
        vm.ageRangeState  = .init(min: 0, max: 25)
        vm.addressState   = nil
    }
}
 
private class ValidValueSpy {
    private(set) var value: Bool = false
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<Bool, Never>) {
        cancellable = publisher
            .sink(receiveValue: { [weak self] state in
                self?.value = state
        })
    }
}

