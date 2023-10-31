//
//  NewPetViewModelFailureTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import XCTest
import Combine

@testable import pethug

class NewPetViewModelFailureTests: XCTestCase {
    private var imageServiceMock: ImageServiceFailureMock!
    private var defaultPetDataSource: DefaultPetDataSourceFailureMock!
    private var defaultPetRepositoryMock: DefaultPetRepositoryFailureMock!
    private var authServiceMock: AuthServiceProtocol!
    
    /* Create two instances of NewPetViewModel for different use cases:
       1. 'vm' is for creating a new pet, and 'pet' is initially set to nil.
          This distinction is crucial for managing the two use cases efficiently.
     
       2. 'editStateVM' is used when editing an existing pet. Due to Xcode's recognition limitations,
          'vm' cannot effectively run the test with the 'petMock' data directly embedded in the constructor
          because it won't recognize it. Instead, it will run the test with 'pet' set to nil,
          which is why 'editStateVM' is necessary for testing the editing functionality.
    */
    private var vm: NewPetViewModel!
    private var editStateVM: NewPetViewModel!
    
    private var isValidFormSpy: ValidValueSpy!
    private var stateSpy: StateValueSpy!
    private var editStateSpy: StateValueSpy!
    
    override func setUp() {
        imageServiceMock = ImageServiceFailureMock()
        defaultPetDataSource = DefaultPetDataSourceFailureMock()
        defaultPetRepositoryMock = DefaultPetRepositoryFailureMock(petDataSource: defaultPetDataSource)
        authServiceMock = AuthServiceSuccessMock()
        
        vm = NewPetViewModel(imageService: imageServiceMock,
                             createPetUseCase: DefaultCreatePetUC(petRepository: defaultPetRepositoryMock),
                             updatePetUseCase: DefaultUpdatePetUC(petRepository: defaultPetRepositoryMock),
                             deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC(petRepository: defaultPetRepositoryMock),
                             authService: authServiceMock,
                             pet: nil)
        
        editStateVM = NewPetViewModel(imageService: imageServiceMock,
                                      createPetUseCase: DefaultCreatePetUC(petRepository: defaultPetRepositoryMock),
                                      updatePetUseCase: DefaultUpdatePetUC(petRepository: defaultPetRepositoryMock),
                                      deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC(petRepository: defaultPetRepositoryMock),
                                      authService: authServiceMock,
                                      pet: petMock)
        
        isValidFormSpy = ValidValueSpy(vm.isValidSubject.eraseToAnyPublisher())
        stateSpy = StateValueSpy(vm.stateSubject.eraseToAnyPublisher())
        editStateSpy = StateValueSpy(editStateVM.stateSubject.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        vm = nil
        editStateVM = nil
        isValidFormSpy = nil
        stateSpy = nil
        editStateSpy = nil
        NetworkMonitor.shared.connect()
    }
    
    //MARK: - From validation
    
    func test_with_formValidation_result_is_false() {
        
        defer {
            XCTAssertFalse(isValidFormSpy.value, "The published value should be false")
        }
        
        XCTAssertFalse(isValidFormSpy.value, "The published value should be false")
        
        // Valid state
        vm.nameState      = "Terry A. Davis"
        vm.galleryState   = [UIImage(systemName: "pencil")!]
        vm.typeState      = .bird
        vm.breedsState    = "Dachshund"
        vm.genderState    = .female
        vm.sizeState      = .small
        vm.ageState       = 15
        vm.activityState  = 5
        vm.socialState    = 6
        vm.affectionState = 420
        vm.addressState   = .MexicoCity
        vm.infoState      = "Pet info"
        
        XCTAssertTrue(isValidFormSpy.value, "The published value should be true")
        
        // Make the form invalid by having nil values
        vm.nameState      = "Terry A. Davis"
        vm.galleryState   = [UIImage(systemName: "pencil")!]
        vm.typeState      = nil
        vm.breedsState    = "Dachshund"
        vm.genderState    = .female
        vm.sizeState      = .small
        vm.ageState       = nil
        vm.activityState  = nil
        vm.socialState    = nil
        vm.affectionState = 420
        vm.addressState   = .MexicoCity
        vm.infoState      = "Pet info"
    }
    
    //MARK: - Create pet
    
    func test_with_failure_create_pet() async throws {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong)], "The published value should be equal to [.error(.someThingWentWrong)]")
        }
        
        XCTAssertFalse(isValidFormSpy.value, "The published value should be false")
        
        vm.nameState      = "Terry A. Davis"
        vm.galleryState   = [UIImage(systemName: "pencil")!]
        vm.typeState      = .bird
        vm.breedsState    = "Dachshund"
        vm.genderState    = .female
        vm.sizeState      = .small
        vm.ageState       = 15
        vm.activityState  = 5
        vm.socialState    = 6
        vm.affectionState = 7
        vm.addressState   = .MexicoCity
        vm.infoState      = "Pet info"
        
        XCTAssertTrue(isValidFormSpy.value, "The published value should be true")
        
        await vm.createPet()
    }
    
    func test_with_networkFailure_create_pet() async throws {
        NetworkMonitor.shared.disconnect()
        
        defer {
            XCTAssertEqual(stateSpy.values, [.networkError], "The published value should be equal to [.networkError]")
        }
        
        XCTAssertFalse(isValidFormSpy.value, "The published value should be false")
        
        vm.nameState      = "Terry A. Davis"
        vm.galleryState   = [UIImage(systemName: "pencil")!]
        vm.typeState      = .bird
        vm.breedsState    = "Dachshund"
        vm.genderState    = .female
        vm.sizeState      = .small
        vm.ageState       = 15
        vm.activityState  = 5
        vm.socialState    = 6
        vm.affectionState = 7
        vm.addressState   = .MexicoCity
        vm.infoState      = "Pet info"
        
        XCTAssertTrue(isValidFormSpy.value, "The published value should be true")
        
        await vm.createPet()
    }
    
    //MARK: - Update Pet
    
    func test_with_failure_update_pet() async throws {
        
        defer {
            XCTAssertEqual(editStateSpy.values, [.error(.someThingWentWrong)], "The published value should be equal to [.error(.someThingWentWrong)]")
        }
        
        await editStateVM.updatePet()
    }
    
    func test_with_networkFailure_update_pet() async throws {
        NetworkMonitor.shared.disconnect()
        
        defer {
            XCTAssertEqual(editStateSpy.values, [.networkError], "The published value should be equal to [.networkError]")
        }
        
        await editStateVM.updatePet()
    }
    
}

//MARK: - Combine publisher Spy

private class StateValueSpy {
    private(set) var values = [NewPetViewModel.LoadingState]()
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<NewPetViewModel.LoadingState, Never>) {
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
