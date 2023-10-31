//
//  NewPetViewModelSuccessTests.swift
//  pethugTests
//
//  Created by Raul Pena on 29/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug


class NewPetViewModelSuccessTests: XCTestCase {
    private var imageServiceMock: ImageServiceSuccessMock!
    private var defaultPetDataSource: DefaultPetDataSourceSuccessMock!
    private var defaultPetRepositoryMock: DefaultPetRepositorySuccessMock!
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
        imageServiceMock = ImageServiceSuccessMock()
        defaultPetDataSource = DefaultPetDataSourceSuccessMock()
        defaultPetRepositoryMock = DefaultPetRepositorySuccessMock(petDataSource: defaultPetDataSource)
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
    }
    
    //MARK: - From validation
    
    func test_with_formValidation_result_is_true() {
        
        defer {
            XCTAssertTrue(isValidFormSpy.value, "The published value should be true")
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
    }
    
    //MARK: - Create pet
    
    func test_with_successful_create_pet() async throws {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.loading, .success], "The published value should be equal to [.loading, .success]")
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
    
    func test_with_successful_update_pet() async throws {
        
        defer {
            XCTAssertEqual(editStateSpy.values, [.loading, .success], "The published value should be equal to [.loading, .success]")
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
                case .loading:
                    self?.values.append(.loading)
                case .success:
                    self?.values.append(.success)
                default:
                    print("error log")
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
