//
//  NewPetViewModel.swift
//  pethug
//
//  Created by Raul Pena on 01/10/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import Combine

class NewPetViewModel {
    //MARK: - Private properties
    private let imageService: ImageServiceProtocol
    private let createPetUseCase: DefaultCreatePetUC
    private let updatePetUseCase: DefaultUpdatePetUC
    private let deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC
    private let uid = AuthService().uid
    private var pet: Pet?

    //MARK: - Init
    init(
        imageService: ImageServiceProtocol,
        createPetUseCase: DefaultCreatePetUC,
        updatePetUseCase: DefaultUpdatePetUC,
        deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC,
        pet: Pet? = nil
    ) {
        self.imageService     = imageService
        self.createPetUseCase = createPetUseCase
        self.updatePetUseCase = updatePetUseCase
        self.deletePetFromRepeatedCollectionUC = deletePetFromRepeatedCollectionUC
        self.pet = pet
        self.isEdit = pet != nil
    
        self.imagesToEditState = pet?.imagesUrls ?? []
        self.nameState      = pet?.name
        self.galleryState   = []
        self.typeState      = pet?.type
        self.breedsState    = pet?.breed
        self.genderState    = pet?.gender
        self.sizeState      = pet?.size
        self.ageState       = pet?.age
        self.activityState  = pet?.activityLevel
        self.socialState    = pet?.socialLevel
        self.affectionState = pet?.affectionLevel
        self.medicalInfoState = pet?.medicalInfo ?? MedicalInfo(internalDeworming: false,
                                                            externalDeworming: false,
                                                            microchip: false,
                                                            sterilized: false,
                                                            vaccinated: false)
        self.socialInfoState =  pet?.socialInfo ?? SocialInfo(maleDogFriendly: false,
                                           femaleDogFriendly: false,
                                           maleCatFriendly: false,
                                           femaleCatFriendly: false)
        self.addressState   = pet?.address
        self.infoState      = pet?.info
        
        observeValidation()
        

    }
    
    
    //MARK: - Form Validation
    private var cancellables = Set<AnyCancellable>()
    
    @Published var nameState:        String? = nil
    @Published var galleryState:     [UIImage] = []
    @Published var typeState:        Pet.PetType? = nil
    @Published var breedsState:      String? = nil
    @Published var genderState:      Pet.Gender? = nil
    @Published var sizeState:        Pet.Size? = nil
    @Published var ageState:         Int? = nil
    @Published var activityState:    Int? = nil
    @Published var socialState:      Int? = nil
    @Published var affectionState:   Int? = nil
    @Published var medicalInfoState: MedicalInfo
    @Published var socialInfoState:  SocialInfo
    @Published var addressState:     Pet.State? = nil
    @Published var infoState:        String? = nil
    
    var imagesToEditState: [String] = []
    var isEdit = false
    var isValidSubject = CurrentValueSubject<Bool, Never>(false)
    var stateSubject = PassthroughSubject<LoadingState, Never>()
    
    func observeValidation() {
        formValidationState.sink(receiveValue: { state in
            switch state {
            case .valid:
                self.isValidSubject.send(true)
            case .invalid:
                self.isValidSubject.send(false)
            }
        }).store(in: &cancellables)
    }
    
    var formValidationState: AnyPublisher<State, Never> {
        return Publishers.CombineLatest4(
            Publishers.CombineLatest4($nameState, $galleryState, $typeState, $breedsState),
            Publishers.CombineLatest4($genderState, $sizeState, $ageState, $activityState),
            Publishers.CombineLatest($socialState, $affectionState),
            Publishers.CombineLatest($addressState, $infoState)
        )
        .map { [weak self] nameGalleryType, breedGenderSize, petStats, addressInfo in
            guard let self = self else { return .invalid }
            let (name, gallery, type, breed) = nameGalleryType
            let (gender, size, age, activity) = breedGenderSize
            let (social, affection) = petStats
            let (address, info) =  addressInfo
            
            return self.validateForm(
                name: name,
                gallery: gallery,
                type: type,
                breed: breed,
                gender: gender,
                size: size,
                age: age,
                activity: activity,
                social: social,
                affection: affection,
                address: address,
                info: info
            )
            
        }
        .eraseToAnyPublisher()
    }
    
    func validateForm(
        name:      String?,
        gallery:   [UIImage],
        type:      Pet.PetType?,
        breed:     String?,
        gender:    Pet.Gender?,
        size:      Pet.Size?,
        age:       Int?,
        activity:  Int?,
        social:    Int?,
        affection: Int?,
        address:   Pet.State?,
        info:      String?
    ) -> State{
        
        if name == nil       ||
            gallery.isEmpty  ||
            type == nil      ||
            breed == nil     ||
            age == nil       ||
            activity == nil  ||
            social == nil    ||
            affection == nil ||
            address == nil   ||
            info == nil {
            return .invalid
        }
        
        return .valid
    }
    
    //MARK: - Upload new pet
    func createPet() async {
        stateSubject.send(.loading)
        
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                stateSubject.send(.networkError)
                return
            }
            var imagesUrls = [String]()
            
            try await uploadNextImage(index: 0, imagesUrls: &imagesUrls)
            
            let pet = Pet(
                id: UUID().uuidString,
                name: nameState!,
                gender: genderState,
                size: sizeState,
                breed: breedsState!,
                imagesUrls: imagesUrls,
                type: typeState!,
                age: ageState!,
                activityLevel: activityState!,
                socialLevel: socialState!,
                affectionLevel: affectionState!,
                address: addressState!,
                info: infoState!,
                medicalInfo: medicalInfoState,
                socialInfo: socialInfoState,
                isLiked: false,
                timestamp: Timestamp(date: Date()),
                owneruid: AuthService().uid,
                likedByUsers: [],
                likesTimestamps: []
            )
            
            let _ = try await executeCreatePet(pet: pet)
            
            stateSubject.send(.success)
            
        } catch {
            stateSubject.send(.error(.default(error)))
        }
        
    }
    
    private func executeCreatePet(pet: Pet) async throws -> Bool{
        let path = pet.type.getPath
        return try await createPetUseCase.execute(collection: path, data: pet)
    }
    
    func updatePet() async {
        
        stateSubject.send(.loading)
        
        do {
            guard NetworkMonitor.shared.isConnected == true else {
                stateSubject.send(.networkError)
                return
            }
            var imagesUrls = [String]()
            
            try await uploadNextImage(index: 0, imagesUrls: &imagesUrls)
            guard let currentPet = pet else { return }
            let pet = Pet(
                id: currentPet.id,
                name: nameState!,
                gender: genderState,
                size: sizeState,
                breed: breedsState!,
                imagesUrls: imagesUrls,
                type: typeState!,
                age: ageState!,
                activityLevel: activityState!,
                socialLevel: socialState!,
                affectionLevel: affectionState!,
                address: addressState!,
                info: infoState!,
                medicalInfo: medicalInfoState,
                socialInfo: socialInfoState,
                isLiked: currentPet.isLiked,
                timestamp: currentPet.timestamp,
                owneruid: currentPet.owneruid,
                likedByUsers: currentPet.likedByUsers,
                likesTimestamps: currentPet.likesTimestamps
            )
            
            let _ = try await executeUpdatePet(pet: pet)

            imageService.deleteImages(imagesUrl: currentPet.imagesUrls)
            stateSubject.send(.success)
            
        } catch {
            stateSubject.send(.error(.default(error)))
        }
        
    }
    
    private func executeUpdatePet(pet: Pet) async throws -> Bool{
        guard let path = self.pet?.type.getPath else { return false}
        return try await updatePetUseCase.execute(data: pet, oldCollection: path)
    }
    
    //Recursively Upload images in sequence to respect the order in which the user selected the images
    func uploadNextImage(index: Int, imagesUrls: inout [String]) async throws {
        guard let _ = typeState else { return }
        let path = "/userImages:\(uid)/"
        
        guard index < galleryState.count else { return }
        
        let image = galleryState[index]
        
        let imageUrl = try await imageService.uploadImage(image: image, path: path)
        if let  imageUrl = imageUrl {
            imagesUrls.append(imageUrl)
        }
        try await uploadNextImage(index: index + 1, imagesUrls: &imagesUrls)
        
        
    }
    //Delete pet from old collection when user changes its type, eg: change from pet -> to bird
    func deleteFromRepeated(collection path: String, id: String) async throws {
        _ = try await deletePetFromRepeatedCollectionUC.execute(collection: path, docId: id)
    }
    
}
    
    
    
    
    
    
    



