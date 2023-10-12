//
//  FilterPetsViewModel.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit
import Firebase
import Combine

class FilterPetsViewModel {
    //MARK: - Private properties
    //MARK: - Internal Properties
    
    init() {
//        self.imageService     = imageService
//        self.createPetUseCase = createPetUseCase
//        self.updatePetUseCase = updatePetUseCase
//        self.deletePetFromRepeatedCollectionUC = deletePetFromRepeatedCollectionUC
//        self.pet = pet
//        self.isEdit = pet != nil
        observeValidation()
//        let imagesArr = getImages(stringUrlArray: pet?.imagesUrls ?? [])
//        self.imagesToEditState = pet?.imagesUrls ?? []
//        self.nameState      = pet?.name
//        self.galleryState   = []
//        self.typeState      = pet?.type
//        self.breedsState    = pet?.breed
//        self.genderState    = pet?.gender
//        self.sizeState      = pet?.size
//        self.ageState       = pet?.age
//        self.activityState  = pet?.activityLevel
//        self.socialState    = pet?.socialLevel
//        self.affectionState = pet?.affectionLevel
//        self.addressState   = pet?.address
//        self.infoState      = pet?.info
        
//        mockDecodePetModel()
    }
    
//    func mockDecodePetModel() {
//        print("corre mock pet model decode 789: => ")
//        let petModel: PetModel = PetModel(id: "3323-ews3", name: "Joanna Camacho", age: 22, gender: "female", size: "small", breed: "Dachshund", imagesUrls: ["firebase.com/ImageExampleMyCousin"], type: "dog", address: "Sinaloa", isLiked: false)
//
//        let petModelData: [String: Any] = [
//            "id": "3323-ews3",
//            "name": "Joanna Camacho",
//            "age": 22,
//            "gender": "female",
//            "size": "small",
//            "breed": "Dachshund",
//            "imagesUrls": ["firebase.com/ImageExampleMyCousin"],
//            "type": "dog",
//            "address": "Sinaloa",
//            "isLiked": false
//        ]
//
//        if let jsonData = try? JSONSerialization.data(withJSONObject: petModelData, options: []) {
//            let pet = try? JSONDecoder().decode(Pet.self, from: jsonData)
//
//            print("data firebase niga PET IN CUSTOM DECODER: => \(pet?.address)")
//        }
//
//    }
    
    //MARK: - Form Validation
    private var cancellables = Set<AnyCancellable>()
    
    @Published var typeState:     Pet.PetType? = nil
    @Published var genderState:   Pet.Gender? = nil
    @Published var sizeState:     Pet.Size? = nil
    @Published var ageState:      Int? = nil
    @Published var addressState:  Pet.State? = nil
    
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
        return Publishers.CombineLatest(
            Publishers.CombineLatest3($typeState, $ageState, $addressState),
            Publishers.CombineLatest($genderState, $sizeState)
        )
        .map { nameGalleryType, breedGenderSize in
            let (type, age, address) = nameGalleryType
            let (gender, size) = breedGenderSize
            
            return self.validateForm(
                type: type,
                gender: gender,
                size: size,
                age: age,
                address: address
            )
            
        }
        .eraseToAnyPublisher()
    }
    
    func validateForm(
        type: Pet.PetType?,
        gender: Pet.Gender?,
        size: Pet.Size?,
        age: Int?,
        address: Pet.State?
    ) -> State{
        //gender and size are optional for the user
//        print("name level en viewmodel: => 666 \(name)")
//        print("gallery level en viewmodel: => 221 \(gallery)")
//        print("gallery level is empty? en viewmodel: => 221 \(gallery.isEmpty)")
//          print("gallery count en viewmodel: => 221 \(gallery.count)")
//        print("type level en viewmodel: => 666 \(type)")
//        print("breed level en viewmodel: => 666 \(breed)")
//        print("age level en viewmodel: => 666 \(age)")
//        print("activity level en viewmodel: => 221 \(activity)")
//        print("social level en viewmodel: => 666 \(social)")
//        print("affection level en viewmodel: => 666 \(affection)")
//        print("address level en viewmodel: => 666 \(address)")
//        print("info level en viewmodel: => 666 \(info)")
//        print("gender en viewmodel: => 666 \(gender)")
        
//       gender and size props are optional
        if type == nil      ||
           age == nil       ||
           address == nil {
           return .invalid
        }
        
        return .valid
    }
    
    
    
}



