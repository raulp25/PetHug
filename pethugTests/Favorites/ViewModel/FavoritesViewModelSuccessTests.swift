//
//  FavoritesViewModelSuccessTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import Foundation

import XCTest
import Combine
import Firebase

@testable import pethug

//This tests will pass if they are run in solitary because of the multiple Task.sleep
// and probably issues with M1 chips or xcode itself 

class FavoritesViewModelSuccessTests: XCTestCase {
    
    private var defaultPetDataSource: DefaultPetDataSourceSuccessMock!
    private var defaultPetRepositoryMock: DefaultPetRepositorySuccessMock!
    private var authServiceMock: AuthServiceSuccessMock!
    private var vm: FavoritesViewModel!
    
    private var stateSpy: StateValueSpy!
    
    private func resetUserDefaultsKeys() {
        for key in FilterKeys.allCases {
            UserDefaults.standard.removeObject(forKey: key.rawValue) //Remove Filter screen options
        }
    }

    override func setUp() {
        resetUserDefaultsKeys()
        defaultPetDataSource = DefaultPetDataSourceSuccessMock()
        defaultPetRepositoryMock = DefaultPetRepositorySuccessMock(petDataSource: defaultPetDataSource)
        authServiceMock = AuthServiceSuccessMock()
        
        vm = FavoritesViewModel(fetchFavoritePetsUC: DefaultFetchFavoritePetsUC(petRepository: defaultPetRepositoryMock),
                                dislikePetUC: DefaultDisLikePetUC(petRepository: defaultPetRepositoryMock),
                                authService: authServiceMock)
        
        stateSpy = StateValueSpy(vm.state.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        vm = nil
        stateSpy = nil
    }
    
    //MARK: - Fetch favorite pets
    
    func test_with_successful_fetch_favorite_pets() async throws {
        defer {
            XCTAssertEqual(stateSpy.values, [petMock, petMock], "The published values should be equal to [petMock, petMock]")
            XCTAssertEqual(vm.pets.count, 2, "The view model pets stete count shoudld be 2" )

            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        }

        XCTAssertEqual(stateSpy.values, [], "The published values should be equal to []")
        XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )

        // async fetchFavoritePets gets called in the init, so we need to wait 200 ms until it completes,
        // otherwise, XCTest won't capture the values correctly.
        try await Task.sleep(nanoseconds: 1 * 0_200_000_000)

        XCTAssertEqual(stateSpy.values, [petMock], "The published values should be equal to [petMock]")
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")

        await vm.fetchFavoritePets(resetData: false)
    }
   
    
    func test_with_successful_fetch_favorite_pets_resulting_in_empty_state() async throws {
        defer {
            // Empty state
            XCTAssertTrue(stateSpy.emptyState, "The published value should be true")
            XCTAssertEqual(stateSpy.values, [petMock, petMock], "The published values should be equal to [petMock, petMock]")
            XCTAssertEqual(vm.pets.count, 2, "The view model pets stete count shoudld be 2" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        }
        
        XCTAssertEqual(stateSpy.values, [petMock], "The published values should be equal to []")
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 0" )
        
        // async fetchFavoritePets gets called in the init, so we need to wait 200 ms until it completes,
        // otherwise, XCTest won't capture the values correctly.
        try await Task.sleep(nanoseconds: 1 * 0_200_000_000)
        
        XCTAssertEqual(stateSpy.values, [petMock], "The published values should be equal to [petMock]")
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        
        await vm.fetchFavoritePets(resetData: false)
        
        XCTAssertEqual(stateSpy.values, [petMock, petMock], "The published values should be equal to [petMock, petMock]")
        XCTAssertEqual(vm.pets.count, 2, "The view model pets stete count shoudld be 2" )
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        
        // On third call of fetchFavoritePets our mocked dataSource will return empty [] so we trigger empty state
        await vm.fetchFavoritePets(resetData: false)
    }
    
    //MARK: - Puede ser que las 3 llamada a fecthfavorites en el mock que retorna empty sea el problema ya veremos
    
    func test_with_successful_dislike_favorite_pet() async throws {
        let expectation = XCTestExpectation(description: "dislikedPet async task")
        
        let petMock = petMock
        let uid = authServiceMock.uid
        petMock.likedByUsers.append(uid)
        petMock.likesTimestamps.append(.init(uid: uid, timestamp: Timestamp(date: Date())))
        
        defer {
            XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 2" )
            XCTAssertEqual(stateSpy.values, [petMock, petMock], "The published values should be equal to [petMock, petMock]")
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        }
        
        XCTAssertEqual(stateSpy.values, [], "The published values should be equal to []")
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 0" )
        
        // async fetchFavoritePets gets called in the init, so we need to wait 200 ms until it completes,
        // otherwise, XCTest won't capture the values correctly.
        try await Task.sleep(nanoseconds: 1 * 0_200_000_000)
        
        XCTAssertEqual(stateSpy.values, [petMock], "The published values should be equal to [petMock]")
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        
        await vm.fetchFavoritePets(resetData: false)
        
        XCTAssertEqual(stateSpy.values, [petMock, petMock], "The published values should be equal to [petMock, petMock]")
        XCTAssertEqual(vm.pets.count, 2, "The view model pets stete count shoudld be 2" )
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        
        await vm.dislikedPet(pet: petMock, completion: { result in
            expectation.fulfill()
            XCTAssertTrue(result, "Result value should be true")
        })
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
}

//MARK: - Combine publisher Spy
 
private class StateValueSpy {
    private(set) var values = [Pet]()
    private(set) var emptyState = false
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<FavoritesViewModel.State, Never>) {
        cancellable = publisher.sink(receiveValue: { [weak self] state in
            switch state {
            case .loaded(let values):
                self?.values = values
            case .empty:
                self?.emptyState = true
            default:
                print("")
            }
        })
    }
}
