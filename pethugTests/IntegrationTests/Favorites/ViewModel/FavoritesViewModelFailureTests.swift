//
//  FavoritesViewModelFailureTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import Foundation

import XCTest
import Combine

@testable import pethug

class FavoritesViewModelFailureTests: XCTestCase {
    
    private var defaultPetDataSource: DefaultPetDataSourceFailureMock!
    private var defaultPetRepositoryMock: DefaultPetRepositoryFailureMock!
    private var authServiceMock: AuthServiceFailureMock!
    private var vm: FavoritesViewModel!
    
    private var stateSpy: StateValueSpy!
    
    override func setUp() {
        defaultPetDataSource = DefaultPetDataSourceFailureMock()
        defaultPetRepositoryMock = DefaultPetRepositoryFailureMock(petDataSource: defaultPetDataSource)
        authServiceMock = AuthServiceFailureMock()
        
        vm = FavoritesViewModel(fetchFavoritePetsUC: DefaultFetchFavoritePetsUC(petRepository: defaultPetRepositoryMock),
                                dislikePetUC: DefaultDisLikePetUC(petRepository: defaultPetRepositoryMock),
                                authService: authServiceMock)
        
        stateSpy = StateValueSpy(vm.state.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        vm = nil
        stateSpy = nil
        NetworkMonitor.shared.connect()
    }
    
    //MARK: - Fetch favorite pets
    
    func test_with_failure_fetch_favorite_pets() async throws {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong), .error(.someThingWentWrong)], "The published values should be equal to [.error(.someThingWentWrong)]")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        }
        
        XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong)], "The published values should be equal to []")
        XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
        
        // async fetchFavoritePets gets called in the init, so we need to wait 200 ms until it completes,
        // otherwise, XCTest won't capture the values correctly.
        try await Task.sleep(nanoseconds: 1 * 0_200_000_000)
        
        await vm.fetchFavoritePets()
    }
    
    func test_with_networkFailure_fetch_favorite_pets() async throws {
        NetworkMonitor.shared.disconnect()
        
        defer {
            XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong), .networkError], "The published values should be equal to [.networkError]")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        }
        
        // async fetchFavoritePets gets called in the init, so we need to wait 200 ms until it completes,
        // otherwise, XCTest won't capture the values correctly.
        try await Task.sleep(nanoseconds: 1 * 0_200_000_000)
        
        await vm.fetchFavoritePets()
    }
    
    func test_with_failure_dislike_favorite_pet() async throws {
        let expectation = XCTestExpectation(description: "dislikedPet async task")
        
        defer {
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 2" )
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        }
        
        XCTAssertEqual(stateSpy.values, [], "The published values should be equal to []")
        XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
    
        await vm.dislikedPet(pet: petMock, completion: { result in
            expectation.fulfill()
            XCTAssertFalse(result, "Result value should be false")
        })
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func test_with_networkFailure_dislike_favorite_pet() async throws {
        NetworkMonitor.shared.disconnect()
        
        let expectation = XCTestExpectation(description: "dislikedPet async task")
        
        defer {
            XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong), .networkError], "The published values should be equal to [.networkError, .networkError]")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 2" )
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        }
        
        XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong)], "The published values should be equal to []")
        XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
    
        await vm.dislikedPet(pet: petMock, completion: { result in
            expectation.fulfill()
            XCTAssertFalse(result, "Result value should be false")
        })
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
}

//MARK: - Combine publisher Spy

private class StateValueSpy {
    private(set) var values = [FavoritesViewModel.State]()
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<FavoritesViewModel.State, Never>) {
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
