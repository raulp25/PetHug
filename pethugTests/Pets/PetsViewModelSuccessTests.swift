//
//  PetsViewModelSuccessTests.swift
//  pethugTests
//
//  Created by Raul Pena on 28/10/23.
//

import XCTest

@testable import pethug


class PetsViewModelSuccessTests: XCTestCase {
    
    private var fetchAllPetsUCMock: DefaultPetRepositoryMock!
    private var vm: PetsViewModel!

    override func setUp() {
        vm = PetsViewModel(fetchAllPetsUC: DefaultFetchAllPetsUC(petRepository: DefaultPetRepositoryMock()),
                           filterAllPetsUC: DefaultFilterAllPetsUC(petRepository: DefaultPetRepositoryMock()),
                           fetchPetsUC: DefaultFetchPetsUC(petRepository: DefaultPetRepositoryMock()),
                           filterPetsUC: DefaultFilterPetsUC(petRepository: DefaultPetRepositoryMock()),
                           likedPetUC: DefaultLikePetUC(petRepository: DefaultPetRepositoryMock()),
                           dislikePetUC: DefaultDisLikePetUC(petRepository: DefaultPetRepositoryMock()))
    }
    
    override func tearDown() {
        vm = nil
    }
    
  
    func test_with_successful_fetch_pets() async {
        
        defer {
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            
            XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
            
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, .getPath(for: .allPets), "The view model collection state should be all pets")
        
        await vm.fetchPets(collection: .getPath(for: .allPets), resetFilterQueries: true)
        

    }

}
