//
//  NewPetViewModel.swift
//  pethug
//
//  Created by Raul Pena on 01/10/23.
//

import UIKit
import Combine

class NewPetViewModel {
    //MARK: - Private properties
    private let imageService: ImageServiceProtocol
    private let useCase: DefaultCreatePetUC
    
    init(imageService: ImageServiceProtocol, useCase: DefaultCreatePetUC) {
        self.imageService = imageService
        self.useCase = useCase
        observeValidation()
        mockDecodePetModel()
    }
    
    func mockDecodePetModel() {
        print("corre mock pet model decode 789: => ")
        let petModel: PetModel = PetModel(id: "3323-ews3", name: "Joanna Camacho", age: 22, gender: "female", size: "small", breed: "Dachshund", imagesUrls: ["firebase.com/ImageExampleMyCousin"], type: "dog", address: "Sinaloa", isLiked: false)
        
        let petModelData: [String: Any] = [
            "id": "3323-ews3",
            "name": "Joanna Camacho",
            "age": 22,
            "gender": "female",
            "size": "small",
            "breed": "Dachshund",
            "imagesUrls": ["firebase.com/ImageExampleMyCousin"],
            "type": "dog",
            "address": "Sinaloa",
            "isLiked": false
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: petModelData, options: []) {
            let pet = try? JSONDecoder().decode(Pet.self, from: jsonData)
        }
       
    }
    
    //MARK: - Form Validation
    private var cancellables = Set<AnyCancellable>()
    
    @Published var nameState:     String? = nil
    @Published var galleryState:  [UIImage] = []
    @Published var typeState:     Pet.PetType? = nil
    @Published var breedsState:   String? = nil
    @Published var genderState:   Pet.Gender? = nil
    @Published var sizeState:     Pet.Size? = nil
    @Published var ageState:      Int? = nil
    @Published var activityState: Int? = nil
    @Published var socialState:   Int? = nil
    @Published var affectionState: Int? = nil
    @Published var addressState:  Pet.State? = nil
    @Published var infoState:     String? = nil
    
    var isValidSubject = CurrentValueSubject<Bool, Never>(false)
    var stateSubject = PassthroughSubject<LoadingState, Never>()
    
    func observeValidation() {
            formValidationState.sink(receiveValue: { state in
                switch state {
                case .valid:
                    self.isValidSubject.send(true)
                    print("is valid 666")
                case .invalid:
                            print("is inValid 666")
                    self.isValidSubject.send(false)
                }
            }).store(in: &cancellables)
    }
    
    var formValidationState: AnyPublisher<State, Never> {
        return Publishers.CombineLatest4(
            Publishers.CombineLatest3($nameState, $galleryState, $typeState),
            Publishers.CombineLatest3($breedsState, $genderState, $sizeState),
            Publishers.CombineLatest4($ageState, $activityState, $socialState, $affectionState),
            Publishers.CombineLatest($addressState, $infoState)
        )
        .map { nameGalleryType, breedGenderSize, petStats, addressInfo in
            let (name, gallery, type) = nameGalleryType
            let (breed, gender, size) = breedGenderSize
            let (age, activity, social, affection) = petStats
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
        name: String?,
        gallery: [UIImage],
        type: Pet.PetType?,
        breed: String?,
        gender: Pet.Gender?,
        size: Pet.Size?,
        age: Int?,
        activity: Int?,
        social: Int?,
        affection: Int?,
        address: Pet.State?,
        info: String?
    ) -> State{
        //gender and size are optional for the user
//        print("name level en viewmodel: => 666 \(name)")
//        print("gallery level en viewmodel: => 221 \(gallery)")
//        print("gallery level is empty? en viewmodel: => 221 \(gallery.isEmpty)")
//        print("type level en viewmodel: => 666 \(type)")
//        print("breed level en viewmodel: => 666 \(breed)")
//        print("age level en viewmodel: => 666 \(age)")
//        print("activity level en viewmodel: => 221 \(activity)")
//        print("social level en viewmodel: => 666 \(social)")
//        print("affection level en viewmodel: => 666 \(affection)")
//        print("address level en viewmodel: => 666 \(address)")
//        print("info level en viewmodel: => 666 \(info)")
        if name == nil      ||
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
            
            var imagesUrls = [String]()
            
            try await withThrowingTaskGroup(of: String.self, body: { group in
                
                for image in galleryState {
                    
                    group.addTask { try await self.imageService.uploadImage(image: image, path: .getStoragePath(for: .petProfile)) ?? "" }
                    
//                    let imageUrl = try await imageService.uploadImage(image: image, path: .getStoragePath(for: .petProfile))
                    
//                    if let imageUrl = imageUrl {
//                        imagesUrls.append(imageUrl)
//                    }
                    
                    for try await image in group {
                        if !image.isEmpty {
                            imagesUrls.append(image)
                        }
                    }
                    
                }
                
            })
            
            let pet = Pet(
                id: UUID().uuidString,
                name: nameState!,
                age: ageState!,
                gender: genderState!,
                size: sizeState!,
                breed: breedsState!,
                imagesUrls: imagesUrls,
                type: typeState!,
                address: addressState!,
                isLiked: false
            )
            
            
            let _ = try await createPet(pet: pet)
            
            stateSubject.send(.success)
            
        } catch {
            stateSubject.send(.error(.default(error)))
        }
        
    }
    
    private func createPet(pet: Pet) async throws -> Bool{
        guard let path = getPath() else {
            stateSubject.send(.error(.someThingWentWrong))
            return false
        }
        
        return try await useCase.execute(collection: path, data: pet)
    }
    
    
    func getPath() -> String? {
        switch typeState {
        case .dog:
            return .getPath(for: .dogs)
        case .cat:
            return .getPath(for: .cats)
        case .bird:
            return .getPath(for: .birds)
        case .rabbit:
            return .getPath(for: .rabbits)
        case .none:
            print("no path")
            return nil
        }
    }
}


