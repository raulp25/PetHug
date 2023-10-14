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
        setInitialValues()
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
//    @Published var typeState:     Pet.PetType? = nil
//    @Published var genderState:   Pet.Gender?  = nil
//    @Published var sizeState:     Pet.Size?    = nil
//    @Published var ageRangeState: (Int, Int)?  = nil
//    @Published var addressState:  Pet.State?   = nil
//
//    var stateSubject = PassthroughSubject<LoadingState, Never>()
//
//    func observeValidation() {
//            formValues.sink(receiveValue: { [weak self] filterOptions in
//                self?.stateSubject.send(.success(filterOptions))
//            }).store(in: &cancellables)
//    }
//
//    var formValues: AnyPublisher<FilterOptions, Never> {
//        return Publishers.CombineLatest(
//            Publishers.CombineLatest3($typeState, $ageRangeState, $addressState),
//            Publishers.CombineLatest($genderState, $sizeState)
//        )
//        .map { nameGalleryType, breedGenderSize in
//            let (type, ageRange, address) = nameGalleryType
//            let (gender, size) = breedGenderSize
//
//            print("agerange changed: => \(ageRange)")
//
//            return FilterOptions(
//                type: type,
//                ageRange: ageRange,
//                address: address,
//                gender: gender,
//                size: size
//            )
//
//        }
//        .eraseToAnyPublisher()
//    }
    
    //MARK: - Form Validation
    private var cancellables = Set<AnyCancellable>()
    
    @Published var typeState:     FilterType = .all
    @Published var genderState:   FilterGender  = .all
    @Published var sizeState:     FilterSize   = .all
    @Published var ageRangeState: FilterAgeRange  = .init(min: 0, max: 25)
    @Published var addressState:  FilterState?   = nil
    
    var isValidSubject = CurrentValueSubject<Bool, Never>(false)
    var stateSubject = PassthroughSubject<LoadingState, Never>()
    
    var filterOptions: FilterOptions!
    private var currentFilterOptions: FilterOptions? = nil
    private var filterKey = "filterOptions"
    
    private func observeValidation() {
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
    
    private var formValidationState: AnyPublisher<State, Never> {
        return Publishers.CombineLatest(
            Publishers.CombineLatest3($typeState, $ageRangeState, $addressState),
            Publishers.CombineLatest($genderState, $sizeState)
        )
        .map { [weak self] nameGalleryType, breedGenderSize in
            guard let self = self else { return .invalid }
            
            let (type, ageRange, address) = nameGalleryType
            let (gender, size) = breedGenderSize
            createFilterOptions(
                type: type,
                gender: gender,
                size: size,
                ageRange: ageRange,
                address: address
            )
            return self.validateForm(
                type: type,
                gender: gender,
                size: size,
                ageRange: ageRange,
                address: address
            )
        }
        .eraseToAnyPublisher()
    }
    
    private func validateForm(
        type: FilterType,
        gender: FilterGender,
        size: FilterSize,
        ageRange: FilterAgeRange,
        address: FilterState?
    ) -> State{
        //gender and size are optional for the user
//        print("name level en viewmodel: => 666 \(name)")
//        print("gallery level en viewmodel: => 221 \(gallery)")
//        print("gallery level is empty? en viewmodel: => 221 \(gallery.isEmpty)")
//          print("gallery count en viewmodel: => 221 \(gallery.count)")
        print("type level en viewmodel: => 931 \(type)")
        print("type state level en viewmodel: => 931 931 \(typeState)")
//        print("breed level en viewmodel: => 666 \(breed)")
//        print("age level en viewmodel: => 666 \(age)")
//        print("activity level en viewmodel: => 221 \(activity)")
//        print("social level en viewmodel: => 666 \(social)")
//        print("affection level en viewmodel: => 666 \(affection)")
//        print("address level en viewmodel: => 666 \(address)")
//        print("info level en viewmodel: => 666 \(info)")
//        print("gender en viewmodel: => 666 \(gender)")
        
//       gender and size props are optional
        
        if let currentFilterOptions = currentFilterOptions {
            let options = FilterOptions(
                type: type,
                gender: gender,
                size: size,
                age: ageRange,
                address: address
            )
            
            print("entra a currentFilterOptions == options: => \(currentFilterOptions == options)")
            print("ns == opti currentFilterOptions : => \(currentFilterOptions)")
            print(" ns == opti options: => \(options)")
            
            
            if currentFilterOptions == options {
                return .invalid
            }
        }
        
        if type   != .all ||
           gender != .all ||
           size   != .all ||
           address != nil {
            return .valid
        }
        
        if ageRange.min != 0 ||
           ageRange.max != 25 {
                return .valid
        }
        
        return.invalid
    }
    
    
    private func createFilterOptions(
        type: FilterType,
        gender: FilterGender,
        size: FilterSize,
        ageRange: FilterAgeRange,
        address: FilterState?
    ) {
        let options = FilterOptions(
                        type: type,
                        gender: gender,
                        size: size,
                        age: ageRange,
                        address: address
                    )
        filterOptions = options
        saveFilterOptionsToUserDefaults(options: options)
        print("optins cuand fomr is valid 931 \(options)")
        print("filter optins = options cuand fomr is valid 931 \(filterOptions)")
    }
    
    private func setInitialValues() {
        if let savedFilterOptions = retrieveFilterOptionsFromUserDefaults() {
            print("savedFilterOptions: => \(savedFilterOptions)")
            currentFilterOptions = savedFilterOptions
            
            typeState     = savedFilterOptions.type
            genderState   = savedFilterOptions.gender
            sizeState     = savedFilterOptions.size
            ageRangeState = savedFilterOptions.age
            addressState  = savedFilterOptions.address
        }
    }
    
    private func saveFilterOptionsToUserDefaults(options: FilterOptions) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(options)
            UserDefaults.standard.set(encodedData, forKey: filterKey)
            let retrievedaftersaved = retrieveFilterOptionsFromUserDefaults()
            print("retrievedaftersaved: => \(retrievedaftersaved)")
        } catch {
            print("Error saving filter options to UserDefaults: \(error)")
        }
    }
    
    private func retrieveFilterOptionsFromUserDefaults() -> FilterOptions? {
        if let encodedData = UserDefaults.standard.data(forKey: filterKey) {
            do {
                let decoder = JSONDecoder()
                let options = try decoder.decode(FilterOptions.self, from: encodedData)
                return options
            } catch {
                print("Error decoding filter options from UserDefaults: \(error)")
            }
        }
        return nil
    }
    
    //MARK: - Public methods
    func resetState() {
        typeState     = .all
        genderState   = .all
        sizeState     = .all
        ageRangeState = .init(min: 0, max: 25)
        addressState  = nil
        
        isValidSubject.send(true)
    }
    
}



