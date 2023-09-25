//
//  Commentaries.swift
//  pethug
//
//  Created by Raul Pena on 24/09/23.
//

import Foundation



//MARK: - DiffableDataSoruce

///FUNCIONA REY DEFINITVA - Had to change from STRUCT to CLASS
///IT SEEMS THAT THERES AN APPLE BUG OR SOMETHING WAST WELL DESING WHEN USING STRUCTS
//
//func didTapLike(_ pet: PetsContentViewController.Item) {
//    guard let indexPath = self.dataSource.indexPath(for: pet) else { return }
//    var item = dataSource.itemIdentifier(for: indexPath)
//    switch pet {
//    case .pet(var pet):
//        pet.isLiked.toggle()
//    }
////        // Update the data source with the modified pet item
////           if case .pet(var petObject) = self.currentSnapData[indexPath.section].values[indexPath.row] {
////               petObject.isLiked.toggle()
////               self.currentSnapData[indexPath.section].values[indexPath.row] = .pet(petObject)
////           }
////
////           // Apply the updated snapshot to the data source
//       var snapshot = self.dataSource.snapshot()
//       snapshot.reloadItems([pet])
//
//       self.dataSource.apply(snapshot, animatingDifferences: false)



//// Works but checking for equality and replacing on the currentSnapData arr is useless since we
///are working with classes [ reference ]
//func didTapLike(_ pet: PetsContentViewController.Item) {
//    guard let indexPath = self.dataSource.indexPath(for: pet) else { return }
//
//    // Update the data source with the modified pet item
//       if case .pet(var petObject) = self.currentSnapData[indexPath.section].values[indexPath.row] {
//           petObject.isLiked.toggle()
//           self.currentSnapData[indexPath.section].values[indexPath.row] = .pet(petObject)
//       }
//
//       // Apply the updated snapshot to the data source
//       var snapshot = self.dataSource.snapshot()
//       snapshot.reloadItems([pet])
//
//       self.dataSource.apply(snapshot, animatingDifferences: false)
//    }


///To remember options of code, theres no need to search for nothing just use the pet parameter
//func didTapLike(_ pet: PetsContentViewController.Item) {
//    guard let indexPath = self.dataSource.indexPath(for: pet) else { return }
//
//    let updatePet = self.currentSnapData[indexPath.section].values[indexPath.row]
//
//    switch updatePet {
//    case .pet(var pet):
//
//
//
//        pet.isLiked.toggle()
//
//        self.currentSnapData[indexPath.section].values.remove(at: indexPath.row)
//        self.currentSnapData[indexPath.section].values.insert(.pet(pet), at: indexPath.row)
//
//
//        let petItem = self.dataSource.itemIdentifier(for: indexPath)
//        var snapshot = self.dataSource.snapshot()
//
//        snapshot.reloadItems([petItem!])
//        self.dataSource.apply(snapshot, animatingDifferences: false)
//    }

