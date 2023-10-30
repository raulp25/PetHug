//
//  AddPetViewModelFailureTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import Foundation

import XCTest
import Combine

@testable import pethug


class AddPetViewModelFailureTests: XCTestCase {
    
    private var imageServiceMock: ImageServiceFailureMock!
    private var defaultPetDataSource: DefaultPetDataSourceFailureMock!
    private var defaultPetRepositoryMock: DefaultPetRepositoryFailureMock!
    private var vm: AddPetViewModel!
    
    private var stateSpy: StateValueSpy!
    
    override func setUp() {
        imageServiceMock = ImageServiceFailureMock()
        defaultPetDataSource = DefaultPetDataSourceFailureMock()
        defaultPetRepositoryMock = DefaultPetRepositoryFailureMock(petDataSource: defaultPetDataSource)
        
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
        NetworkMonitor.shared.connect()
    }
    
    //MARK: - Fetch user pets
    
    func test_with_failure_fetch_user_pets_with_pagination() async throws {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong)], "The published values should be equal to [.error(.someThingWentWrong)]")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        
        await vm.fetchUserPets()
    }
    
    func test_with_networkFailure_fetch_user_pets_with_pagination() async throws {
        NetworkMonitor.shared.disconnect()
        
        defer {
            XCTAssertEqual(stateSpy.values, [.networkError], "The published values should be equal to [.error(.someThingWentWrong)]")
            XCTAssertFalse(vm.isNetworkOnline, "The view model isNetworkOnline state should be false")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        
        await vm.fetchUserPets()
    }
    
    //MARK: - Delete pet
    
    func test_with_failure_delete_pet() async throws {
        var result = false
        
        defer {
            XCTAssertFalse(result, "The view model result from deleting a pet should be false")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        
        result = await vm.deletePet(collection: .getPath(for: .birds), id: petMock.id)
    }
    
    func test_with_networkFailure_delete_pet() async throws {
        NetworkMonitor.shared.disconnect()
        
        var result = false
        
        defer {
            XCTAssertFalse(result, "The view model result from deleting a pet should be false")
            XCTAssertEqual(stateSpy.values, [.networkError], "The published values should be equal to [.error(.someThingWentWrong)]")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        
        result = await vm.deletePet(collection: .getPath(for: .birds), id: petMock.id)
    }
}

//MARK: - Combine publisher Spy

private class StateValueSpy {
    private(set) var values = [AddPetViewModel.State]()
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<AddPetViewModel.State, Never>) {
        cancellable = publisher
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .error(_):
                    self?.values.append(.error(.someThingWentWrong))
                case .networkError:
                    self?.values.append(.networkError)
                default:
                    print("not an error log")
                }
        })
    }
}
