//
//  PetsViewModel.swift
//  pethug
//
//  Created by Raul Pena on 19/09/23.
//

import Foundation
import Combine
import FirebaseFirestore
protocol PetsNavigatable: AnyObject {
    func tapped(pet: Pet)
}

final class PetsViewModel {
    //MARK: - Internal Properties
    weak var navigation: PetsNavigatable?
    var state = PassthroughSubject<State,Never>()
    
//    var fetchPetsUseCase
    
    //MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    
    private let petsSubject = PassthroughSubject<[Pet], PetsError>()
    @Published private var pets: [Pet] = []
    
    
    init() {
    }
    
    deinit {
        print("✅ Deinit PetsViewModel")
    }
    
    //MARK: - Private methods
    private func fetchPets(collection: String) {
        
    }
    
    
}


