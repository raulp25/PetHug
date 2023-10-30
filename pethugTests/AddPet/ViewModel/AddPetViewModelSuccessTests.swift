//
//  AddPetViewModelSuccessTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import Foundation

import XCTest
import Combine

@testable import pethug


class AddPetViewModelSuccessTests: XCTestCase {
    
    private var imageServiceMock: ImageServiceSuccessMock!
    private var defaultPetDataSource: DefaultPetDataSourceSuccessMock!
    private var defaultPetRepositoryMock: DefaultPetRepositorySuccessMock!
    private var vm: AddPetViewModel!
    
    private var stateSpy: StateValueSpy!
    
    override func setUp() {
        imageServiceMock = ImageServiceSuccessMock()
        defaultPetDataSource = DefaultPetDataSourceSuccessMock()
        defaultPetRepositoryMock = DefaultPetRepositorySuccessMock(petDataSource: defaultPetDataSource)
        
        vm = AddPetViewModel(imageService: imageServiceMock,
                             fetchUserPetsUC: DefaultFetchUserPetsUC(petRepository: defaultPetRepositoryMock),
                             deletePetUC: DefaultDeletePetUC.init(petRepository: defaultPetRepositoryMock),
                             deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC(petRepository: defaultPetRepositoryMock)
                             )
        
        stateSpy = StateValueSpy(vm.state.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        vm = nil
        stateSpy = nil
    }
    
    //MARK: - Fetch user pets
    
    func test_with_successful_fetch_user_pets_with_pagination() async throws {
        
        defer {
            XCTAssertEqual(stateSpy.values, [petMock], "The published values should be equal to [petMock]")
            XCTAssertEqual(stateSpy.booleans, [false, false, true], "The published values should be equal to [false, false, true]")
            XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        
        await vm.fetchUserPets()
        
        XCTAssertEqual(stateSpy.values, [petMock], "The published values should be equal to [petMock]")
        XCTAssertEqual(stateSpy.booleans, [false], "The published values should be equal to [false]")
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        
        await vm.fetchUserPets()
        
        XCTAssertEqual(stateSpy.values, [petMock, petMock], "The published values should be equal to [petMock, petMock]")
        XCTAssertEqual(stateSpy.booleans, [false, false], "The published values should be equal to [true, false]")
        XCTAssertEqual(vm.pets.count, 2, "The view model pets stete count shoudld be 2" )
        
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        
        await vm.fetchUserPets(resetPagination: true)
    }
    
    //MARK: - Delete pet
    
    func test_with_successful_delete_pet() async throws {
        var result = false
        
        defer {
            XCTAssertTrue(result, "The view model result from deleting a pet should be true")
            XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
            XCTAssertEqual(stateSpy.booleans, [false, false], "The published values should be equal to [false, false]")
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        
        await vm.fetchUserPets(resetPagination: false)
        
        XCTAssertEqual(stateSpy.values, [petMock], "The published values should be equal to [petMock]")
        XCTAssertEqual(stateSpy.booleans, [false], "The published values should be equal to [false]")
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        
        await vm.fetchUserPets(resetPagination: false)
        
        XCTAssertEqual(stateSpy.values, [petMock, petMock], "The published values should be equal to [petMock, petMock]")
        XCTAssertEqual(stateSpy.booleans, [false, false], "The published values should be equal to [true, false]")
        XCTAssertEqual(vm.pets.count, 2, "The view model pets stete count shoudld be 2" )
        
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        
        result = await vm.deletePet(collection: .getPath(for: .birds), id: petMock.id)
    }
}

private class StateValueSpy {
    private(set) var values = [Pet]()
    private(set) var booleans = [Bool]()
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<AddPetViewModel.State, Never>) {
        cancellable = publisher.sink(receiveValue: { [weak self] state in
            switch state {
            case let .loaded(pets, debounce):
                self?.values = pets
                self?.booleans.append(debounce)
            default:
                print("")
            }
        })
    }
}
