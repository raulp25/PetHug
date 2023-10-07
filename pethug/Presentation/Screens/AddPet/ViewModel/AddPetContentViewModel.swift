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
    private let deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC
    ///Change to FetchUserPetsUC
    init(deletePetUC: DefaultDeletePetUC, deletePetFromRepeatedCollectionUC: DefaultDeletePetFromRepeatedCollectionUC) {
        self.deletePetUC = deletePetUC
        self.deletePetFromRepeatedCollectionUC = deletePetFromRepeatedCollectionUC
    }
    
    deinit {
        print("✅ Deinit PetsViewModel")
    }
    
    //MARK: - Private methods
    func deletePet(collection path: String,  id: String) async -> Bool {
        do {
            await withThrowingTaskGroup(of: Void.self) { [unowned self] group in
                group.addTask { let _ = try await self.deletePetUC.execute(collection: path, docId: id) }
                group.addTask { let _ = try await self.deletePetFromRepeatedCollectionUC.execute(collection: path, docId: id) }
            }
            
            return true
        } catch {
            print("error deleting pet: => \(error.localizedDescription)")
            return false
        }
        
    }
}
    
