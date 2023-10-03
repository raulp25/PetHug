//
//  NewPetViewModel.swift
//  pethug
//
//  Created by Raul Pena on 01/10/23.
//

import UIKit
import Combine

class NewPetViewModel {
    
    enum State {
        case valid
        case invalid
    }
    
    //MARK: - Properties
    @Published var nameState: String? = nil
    @Published var galleryState: [UIImage] = []
    @Published var typeState: Pet.PetType? = nil
    @Published var breedsState: String? = nil
    @Published var genderState: Pet.Gender? = nil
    @Published var sizeState: Pet.Size? = nil
    @Published var addressState: Pet.State? = nil
    @Published var infoState: String? = nil
    
    var isValid = CurrentValueSubject<Bool, Never>(false)
    private var cancellables = Set<AnyCancellable>()
//    private var statePublisher: AnyPublisher<(String?, String?), Never> {
//        return Publishers.CombineLatest($nameState, $addressState)
//            .removeDuplicates { prev, curr in
//                prev == curr
//            }.eraseToAnyPublisher()
//    }
    
    init() {
        observeValidation()
    }
    
    func observeValidation() {
            formValidationState.sink(receiveValue: { state in
                switch state {
                case .valid:
                    self.isValid.send(true)
                case .invalid:
                    self.isValid.send(false)
                }
            }).store(in: &cancellables)
    }
    
    var formValidationState: AnyPublisher<NewPetViewModel.State, Never> {
        return Publishers.CombineLatest3(
            Publishers.CombineLatest3($nameState, $galleryState, $typeState),
            Publishers.CombineLatest3($breedsState, $genderState, $sizeState),
            Publishers.CombineLatest($addressState, $infoState)
        )
        .map { nameGalleryType, breedGenderSize, addressInfo in
            let (name, gallery, type) = nameGalleryType
            let (breeds, gender, size) = breedGenderSize
            let (address, info) = addressInfo
            
//            return [name, gallery]
            
//            print("name inside validation publisher fn: => \(name)")
//            print("info inside validation publisher fn: => \(info)")
            
            return self.validateForm(
                name: name,
                gallery: gallery,
                type: type,
                breeds: breeds,
                gender: gender,
                size: size,
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
        breeds: String?,
        gender: Pet.Gender?,
        size: Pet.Size?,
        address: Pet.State?,
        info: String?
    ) -> State{
        guard name != nil else { return .invalid }
//        guard gallery.count > 0 else { return .invalid }
        guard type != nil else { return .invalid }
//        guard let breeds = breeds else { return .invalid }
        //gender and size are optional
//        guard let address = address else { return .invalid }
        guard info != nil else { return .invalid }
        
        return .valid
    }
    
    
}


