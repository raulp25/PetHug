//
//  PetsViewModelFailureTests.swift
//  pethugTests
//
//  Created by Raul Pena on 29/10/23.
//

import XCTest
import Combine

@testable import pethug

class PetsViewModelFailureTests: XCTestCase {
    private var defaultPetDataSource: DefaultPetDataSourceFailureMock!
    private var defaultPetRepositoryMock: DefaultPetRepositoryFailureMock!
    private var authServiceMock: AuthServiceProtocol!
    private var vm: PetsViewModel!
    
    private var spy: ValueSpy!
    
    override func setUp() {
        defaultPetDataSource = DefaultPetDataSourceFailureMock()
        defaultPetRepositoryMock = DefaultPetRepositoryFailureMock(petDataSource: defaultPetDataSource)
        authServiceMock = AuthServiceFailureMock()
        vm = PetsViewModel(fetchAllPetsUC: DefaultFetchAllPetsUC(petRepository: defaultPetRepositoryMock),
                           filterAllPetsUC: DefaultFilterAllPetsUC(petRepository: defaultPetRepositoryMock),
                           fetchPetsUC: DefaultFetchPetsUC(petRepository: defaultPetRepositoryMock),
                           filterPetsUC: DefaultFilterPetsUC(petRepository: defaultPetRepositoryMock),
                           likedPetUC: DefaultLikePetUC(petRepository: defaultPetRepositoryMock),
                           dislikePetUC: DefaultDisLikePetUC(petRepository: defaultPetRepositoryMock),
                           authService: authServiceMock)
       spy = ValueSpy(vm.state.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        vm = nil
        spy = nil
        NetworkMonitor.shared.connect()
    }
    
    //MARK: - Fetch pets
    
    func test_with_failure_fetch_all_pets_collection() async throws {
        
        let collection: String = .getPath(for: .allPets)
        
        defer {
            XCTAssertEqual(spy.values, 4, "The published error values should be equal to 4")
            
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
    }
    
    func test_with_networkFailure_fetch_all_pets_collection() async throws {
        NetworkMonitor.shared.disconnect()
        
        let collection: String = .getPath(for: .allPets)
        
        defer {
            XCTAssertFalse(NetworkMonitor.shared.isConnected, "The networkMonitor isConnected state should be false")
            XCTAssertEqual(spy.values, 4, "The published error values should be equal to 4")
            
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
    }
    
    func test_with_failure_fetch_particular_pets_collection() async {
        let collection: String = .getPath(for: .birds)
        
        defer {
            XCTAssertEqual(spy.values, 4, "The published values should be equal to 4")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
            
        }
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, .getPath(for: .allPets), "The view model collection state should be \(collection)")
        
        vm.collection = collection
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be birds")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
    }
    
    func test_with_networkFailure_fetch_particular_pets_collection() async {
        NetworkMonitor.shared.disconnect()
        
        let collection: String = .getPath(for: .birds)
        
        defer {
            XCTAssertFalse(NetworkMonitor.shared.isConnected, "The networkMonitor isConnected state should be false")
            XCTAssertEqual(spy.values, 4, "The published error values should be equal to 4")
            print("spy values: => \(spy.values)")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
            
        }
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, .getPath(for: .allPets), "The view model collection state should be \(collection)")
        
        vm.collection = collection
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be birds")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
    }
    
    func test_with_failure_fetch_all_pets_collection_with_filter_options() async {
    
        let collection: String = .getPath(for: .allPets)
        
        defer {
            XCTAssertEqual(spy.values, 4, "The published values should be equal to 4")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNotNil(vm.filterOptions, "The view model filter options should not be nil")
            XCTAssertEqual(vm.filterOptions, filterOptionsMock, "The view model filterOptions state should be equal to filterOptionsMock")
            XCTAssertTrue(vm.filterMode, "The view model filter mode state should be true")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
    }
    
    func test_with_networkFailure_fetch_all_pets_collection_with_filter_options() async {
        NetworkMonitor.shared.disconnect()
        
        let collection: String = .getPath(for: .allPets)
        
        defer {
            XCTAssertEqual(spy.values, 4, "The published values should be equal to 4")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNotNil(vm.filterOptions, "The view model filter options should not be nil")
            XCTAssertEqual(vm.filterOptions, filterOptionsMock, "The view model filterOptions state should be equal to filterOptionsMock")
            XCTAssertTrue(vm.filterMode, "The view model filter mode state should be true")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
    }
    
    func test_with_failure_fetch_particular_pets_collection_with_filter_options() async {
        
        let collection: String = .getPath(for: .birds)
        
        defer {
            XCTAssertEqual(spy.values, 4, "The published values should be equal to 4")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNotNil(vm.filterOptions, "The view model filter options should not be nil")
            XCTAssertEqual(vm.filterOptions, filterOptionsMock, "The view model filterOptions state should be equal")
            XCTAssertTrue(vm.filterMode, "The view model filter mode state should be true")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        
        vm.collection = collection
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
    }
    
    func test_with_networkFailure_fetch_particular_pets_collection_with_filter_options() async {
        NetworkMonitor.shared.disconnect()
        
        let collection: String = .getPath(for: .birds)
        
        defer {
            XCTAssertEqual(spy.values, 4, "The published values should be equal to 4")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNotNil(vm.filterOptions, "The view model filter options should not be nil")
            XCTAssertEqual(vm.filterOptions, filterOptionsMock, "The view model filterOptions state should be equal")
            XCTAssertTrue(vm.filterMode, "The view model filter mode state should be true")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        
        vm.collection = collection
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
        await vm.fetchPetsWithFilter(options: filterOptionsMock, resetFilterQueries: true)
    }
    
    func test_with_failure_fetch_all_pets_collection_with_pagination() async {
        let collection: String = .getPath(for: .allPets)
        
        defer {
            XCTAssertEqual(spy.values, 2, "The published values should be equal to 2")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
            
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        
        XCTAssertEqual(spy.values, 1, "The published values should be equal to 1")
        
        XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: false)
    }
    
    func test_with_networkFailure_fetch_all_pets_collection_with_pagination() async {
        NetworkMonitor.shared.disconnect()
        
        let collection: String = .getPath(for: .allPets)
        
        defer {
            XCTAssertEqual(spy.values, 2, "The published values should be equal to 2")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
            
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        
        XCTAssertEqual(spy.values, 1, "The published values should be equal to 1")
        
        XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: false)
    }
    
    func test_with_failure_fetch_particular_pets_collection_with_pagination() async {
        let collection: String = .getPath(for: .birds)
        
        defer {
            XCTAssertEqual(spy.values, 2, "The published values should be equal to 2")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
            
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        
        vm.collection = collection
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        
        XCTAssertEqual(spy.values, 1, "The published values should be equal to 1")
        
        XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: false)
    }
    
    func test_with_networkFailure_fetch_particular_pets_collection_with_pagination() async {
        NetworkMonitor.shared.disconnect()
        
        let collection: String = .getPath(for: .birds)
        
        defer {
            XCTAssertEqual(spy.values, 2, "The published values should be equal to 2")
            XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
            
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        
        vm.collection = collection
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        
        XCTAssertEqual(spy.values, 1, "The published values should be equal to 1")
        
        XCTAssertEqual(vm.pets.count, 0, "The view model pets stete count shoudld be 0" )
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: false)
    }
    
    //MARK: - Like pet
    
    func test_with_failure_like_pet_request() async {
        
        let expectation = XCTestExpectation(description: "Failure likedPet async task")
        
        defer {
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        }
        
        await vm.likedPet(pet: petMock, completion: { result in
            expectation.fulfill()
            XCTAssertFalse(result, "Result value should be false")
        })
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func test_with_networkFailure_like_pet_request() async {
        NetworkMonitor.shared.disconnect()
        
        defer {
            XCTAssertEqual(spy.values, 2, "The published values should be equal to 2")
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        }
        
        await vm.likedPet(pet: petMock, completion: { _ in })
        await vm.likedPet(pet: petMock, completion: { _ in })
    }
    
    //MARK: - Dislike pet
    
    func test_with_failure_dislike_pet_request() async {
        
        let expectation = XCTestExpectation(description: "likedPet async task")
        
        defer {
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        }
        
        await vm.dislikedPet(pet: petMock) { result in
            expectation.fulfill()
            XCTAssertFalse(result, "Result value should be false")
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func test_with_networkFailure_dislike_pet_request() async {
        NetworkMonitor.shared.disconnect()
    
        defer {
            XCTAssertEqual(spy.values, 2, "The published values should be equal to 2")
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        }
        
        await vm.dislikedPet(pet: petMock) { _ in }
        await vm.dislikedPet(pet: petMock) { _ in }
    }
    
}

//MARK: - Combine publisher Spy

private class ValueSpy {
    private(set) var values: Int = 0
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<PetsViewModel.State, Never>) {
        cancellable = publisher.sink(receiveValue: { [weak self] state in
            switch state {
            case .error(_):
                self?.values += 1
            case .networkError:
                self?.values += 1
            default:
                print("")
            }
        })
    }
}
