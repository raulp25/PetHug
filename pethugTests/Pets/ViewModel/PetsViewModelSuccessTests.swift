//
//  PetsViewModelSuccessTests.swift
//  pethugTests
//
//  Created by Raul Pena on 28/10/23.
//

import XCTest
import Combine

@testable import pethug


class PetsViewModelSuccessTests: XCTestCase {
    
    private var defaultPetDataSource: DefaultPetDataSourceSuccessMock!
    private var defaultPetRepositoryMock: DefaultPetRepositorySuccessMock!
    private var authServiceMock: AuthServiceProtocol!
    private var vm: PetsViewModel!
    
    private var spy: ValueSpy!
    
    override func setUp() {
        defaultPetDataSource = DefaultPetDataSourceSuccessMock()
        defaultPetRepositoryMock = DefaultPetRepositorySuccessMock(petDataSource: defaultPetDataSource)
        authServiceMock = AuthServiceSuccessMock()
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
    }
  
    //MARK: - Fetch pets
    
    func test_with_successful_fetch_all_pets_collection() async throws {
        
        let collection: String = .getPath(for: .allPets)
        
        defer {
            XCTAssertEqual(spy.values, [petMock], "The published values should be equal to 1")
            XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
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
    }
    
    
      func test_with_successful_fetch_particular_pets_collection() async {
          
          let collection: String = .getPath(for: .birds)
          
          defer {
              XCTAssertEqual(spy.values, [petMock], "The published values should be equal to 1")
              XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
              
              XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
              XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
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
      }
    
    //MARK: - Fetch pets with filter
    
    func test_with_successful_fetch_all_pets_collection_with_filter_options() async {
        
        let collection: String = .getPath(for: .allPets)
        
        defer {
            XCTAssertEqual(spy.values, [petMock], "The published values should be equal to 1")
            XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
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
    }
    
    
    func test_with_successful_fetch_particular_pets_collection_with_filter_options() async {
        
        let collection: String = .getPath(for: .birds)
        
        defer {
            XCTAssertEqual(spy.values, [petMock], "The published values should be equal to 1")
            XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
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
    }
    
    //MARK: - Fetch pets with pagination
    
    func test_with_successful_fetch_all_pets_collection_with_pagination() async {
        let collection: String = .getPath(for: .allPets)
        
        defer {
            XCTAssertEqual(spy.values, [petMock, petMock], "The published values should be equal to 2")
            XCTAssertEqual(vm.pets.count, 2, "The view model pets stete count shoudld be 1" )
            
            XCTAssertEqual(vm.pets[1], petMock, "The view model pet[0] state should be equal to petMock")
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
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
        
        XCTAssertEqual(spy.values, [petMock], "The published values should be equal to 1")
        
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        XCTAssertEqual(vm.pets[0], petMock, "The view model pet[0] state should be equal to petMock")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: false)
    }
    
    func test_with_successful_fetch_particular_pets_collection_with_pagination() async {
        let collection: String = .getPath(for: .birds)
        
        defer {
            XCTAssertEqual(spy.values, [petMock, petMock], "The published values should be equal to 1")
            XCTAssertEqual(vm.pets.count, 2, "The view model pets stete count shoudld be 1" )
            
            XCTAssertEqual(vm.pets[1], petMock, "The view model pet[0] state should be equal to petMock")
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
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
        
        XCTAssertEqual(spy.values, [petMock], "The published values should be equal to 1")
        
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        XCTAssertEqual(vm.pets[0], petMock, "The view model pet[0] state should be equal to petMock")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: false)
    }
    
    //MARK: - Like pet
    
    func test_with_successful_like_pet_request() async {
        
        let expectation = XCTestExpectation(description: "likedPet async task")
        
        let collection: String = .getPath(for: .dogs)
        
        defer {
            XCTAssertTrue(vm.pets[0].likedByUsers.contains(authServiceMock.uid), "The view model pet[0].likedByUsers should contain the owneruid")
            XCTAssertEqual(vm.pets[0].likesTimestamps[0].uid, authServiceMock.uid, "The view model pet[0].likesTimestamps uid should be equal to owneruid")
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
            XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        
        vm.collection = collection
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        XCTAssertEqual(vm.pets[0], petMock, "The view model pet[0] state should be equal to petMock")
        
        await vm.likedPet(pet: vm.pets[0], completion: { result in
            expectation.fulfill()
            XCTAssertTrue(result, "Result value should be true")
        })
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    //MARK: - Dislike pet
    
    func test_with_successful_dislike_pet_request() async {
        
        let expectation = XCTestExpectation(description: "likedPet async task")
        expectation.expectedFulfillmentCount = 2
        
        let collection: String = .getPath(for: .dogs)
        
        defer {
            XCTAssertFalse(vm.pets[0].likedByUsers.contains(authServiceMock.uid), "The view model pet[0].likedByUsers should not contain the owneruid")
            XCTAssertTrue(vm.pets[0].likesTimestamps.isEmpty, "The view model pet[0].likesTimestamps should be empty")
            
            XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
            XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
            XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
            XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
            XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
            XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        }
        
        XCTAssertEqual(vm.pets, [], "The view model pets state should be empty")
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertTrue(vm.isFirstLoad, "The view model isFirstLoad state should be true")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        
        vm.collection = collection
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        await vm.fetchPets(collection: collection, resetFilterQueries: true)
        
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        XCTAssertEqual(vm.pets[0], petMock, "The view model pet[0] state should be equal to petMock")
        
        await vm.likedPet(pet: vm.pets[0], completion: { result in
            expectation.fulfill()
            XCTAssertTrue(result, "Result value should be true")
        })
        
        XCTAssertFalse(vm.isFetching, "The view model isFetching state should be false")
        XCTAssertFalse(vm.isFirstLoad, "The view model isFirstLoad state should be false")
        XCTAssertNil(vm.filterOptions, "The view model filter options should be nil")
        XCTAssertFalse(vm.filterMode, "The view model filter mode state should be false")
        XCTAssertEqual(vm.collection, collection, "The view model collection state should be \(collection)")
        XCTAssertEqual(vm.pets.count, 1, "The view model pets stete count shoudld be 1" )
        
        XCTAssertTrue(vm.pets[0].likedByUsers.contains(authServiceMock.uid), "The view model pet[0].likedByUsers should contain the owneruid")
        
        await vm.dislikedPet(pet: vm.pets[0]) { result in
            expectation.fulfill()
            XCTAssertTrue(result, "Result value should be true")
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
}

//MARK: - Combine publisher Spy
 
private class ValueSpy {
    private(set) var values = [Pet]()
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<PetsViewModel.State, Never>) {
        cancellable = publisher.sink(receiveValue: { [weak self] state in
            switch state {
            case .loaded(let values):
                self?.values = values
            default:
                print("")
            }
        })
    }
}
