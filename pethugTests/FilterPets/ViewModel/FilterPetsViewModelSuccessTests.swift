//
//  FilterPetsViewModelSuccessTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug


class FilterPetsViewModelSuccessTests: XCTestCase {
    private var vm: FilterPetsViewModel!
    private var isValidFormSpy: ValidValueSpy!
    
    override func setUp() {
        vm = FilterPetsViewModel()
        isValidFormSpy = ValidValueSpy(vm.isValidSubject.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        vm = nil
        isValidFormSpy = nil
    }
    
    //MARK: - From validation
    
    func test_with_formValidation_result_is_true() {
        
        defer {
            XCTAssertTrue(isValidFormSpy.value, "The published value should be true")
        }
        
        XCTAssertFalse(isValidFormSpy.value, "The published value should be false")
        
        vm.genderState    = .female
        vm.sizeState      = .small
        vm.ageRangeState  = .init(min: 7, max: 15)
        vm.addressState   = .Colima
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
