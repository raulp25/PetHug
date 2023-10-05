//
//  AddPetContentViewModel.swift
//  pethug
//
//  Created by Raul Pena on 04/10/23.
//

import Foundation
import Combine
import FirebaseFirestore

final class AddPetContentViewModel {
    //MARK: - Private Properties
    private let deletePetUC: DefaultDeletePetUC
    
    ///Change to FetchUserPetsUC
    init(deletePetUC: DefaultDeletePetUC) {
        self.deletePetUC = deletePetUC
    }
    
    deinit {
        print("✅ Deinit PetsViewModel")
    }
    
    //MARK: - Private methods
    func deletePet(collection path: String,  id: String) async -> Bool {
        do {
            let result = try await deletePetUC.execute(collection: path, docId: id)
            return result
        } catch {
            print("error deleting pet: => \(error.localizedDescription)")
            return false
        }
        
    }
}
    
