//
//  Commentaries.swift
//  pethug
//
//  Created by Raul Pena on 24/09/23.
//

import Foundation



//MARK: - DiffableDataSoruce===========================================================================

///Works but Had to leave this strategy since we are using classes si theres no need to toggle the liked property
///directly on the viewcontroller, instead we do it from the cell
///IT SEEMS THAT THERES AN APPLE BUG OR SOMETHING WAST WELL DESING WHEN USING STRUCTS
//extension PetsContentViewController: PetContentDelegate {
//    func didTapLike(_ pet: PetsContentViewController.Item) {
//        switch pet {
//        case .pet(let pet):
//            pet.isLiked.toggle()
//        }
//
//        var snapshot = dataSource.snapshot()
//        snapshot.reloadItems([pet])
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
//}

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


///Upload single section
//func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//    picker.dismiss(animated: true, completion: nil)
//
//    guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
//    print("image despues de elgiir: => \(image)")
//    logoImageView.image = image
//
//
//
//    if let gallerySectionIndex = currentSnapData.firstIndex(where: { $0.key == .gallery }) {
//        currentSnapData[gallerySectionIndex].values.append(.image(image))
//
//        snapshot = Snapshot()
//
//        snapshot.appendSections([.gallery])
//        snapshot.appendItems(currentSnapData[gallerySectionIndex].values, toSection: .gallery)
//
//
//        dataSource.apply(snapshot, animatingDifferences: true)
//
//       }
//
////           snapshot = Snapshot()
////           snapshot.appendSections(currentSnapData.map { $0.key })
////
////           for datum in currentSnapData {
////               snapshot.appendItems(datum.values, toSection: datum.key)
////           }
////           dataSource.apply(snapshot, animatingDifferences: true)
//}


///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

///UIBUTTON============================================================
//set tag
//button.tag = CurrentChecked.cat.rawValue

//    enum CurrentChecked: String {
//        case dog
//        case cat
//        case bird
//        case rabbit
//
//    }
//    var currentButton: CurrentChecked? = nil
///~1st way horrible
//    @objc func didTapCheckMark(_ sender: UIButton) {
//        if sender == dogCheckMarkButton && currentButton == .dog {
//           sender.setImage(UIImage(systemName: "square"), for: .normal)
//           sender.tintColor = .black
//        } else if sender == dogCheckMarkButton {
//            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//            sender.tintColor = .systemOrange
//            currentButton = .dog
//        } else {
//            dogCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
//            dogCheckMarkButton.tintColor = .black
//        }
//
//        if sender == catCheckMarkButton && currentButton == .cat {
//           sender.setImage(UIImage(systemName: "square"), for: .normal)
//           sender.tintColor = .black
//        } else if sender == catCheckMarkButton {
//            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//            sender.tintColor = .systemOrange
//            currentButton = .cat
//        } else {
//            catCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
//            catCheckMarkButton.tintColor = .black
//        }
//
//        if sender == birdCheckMarkButton && currentButton == .bird {
//           sender.setImage(UIImage(systemName: "square"), for: .normal)
//           sender.tintColor = .black
//        } else if sender == birdCheckMarkButton {
//            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//            sender.tintColor = .systemOrange
//            currentButton = .bird
//        } else {
//            birdCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
//            birdCheckMarkButton.tintColor = .black
//        }
//
//        if sender == rabbitCheckMarkButton && currentButton == .rabbit {
//           sender.setImage(UIImage(systemName: "square"), for: .normal)
//           sender.tintColor = .black
//        } else if sender == rabbitCheckMarkButton {
//            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//            sender.tintColor = .systemOrange
//            currentButton = .rabbit
//        } else {
//            rabbitCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
//            rabbitCheckMarkButton.tintColor = .black
//        }
//    }

//enum CurrentChecked: Int {
//    case dog = 1
//    case cat = 2
//    case bird = 3
//    case rabbit = 4
//}
//
//var currentButton: CurrentChecked? = nil
//var buttons: [UIButton] = []

///~2nd way but bulkier
//    @objc func didTapCheckMark(_ sender: UIButton) {
//        print("sender tag: => \(sender.tag)")
//        print("CurrentChecked(rawValue: sender.tag) : => \(CurrentChecked(rawValue: sender.tag) )")
//        guard let checked = CurrentChecked(rawValue: sender.tag) else {
//            return
//        }
//
//        // Reset all buttons to "square"
//        dogCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
//        catCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
//        birdCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
//        rabbitCheckMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
//
//        // Reset all buttons to black color
//        dogCheckMarkButton.tintColor = .black
//        catCheckMarkButton.tintColor = .black
//        birdCheckMarkButton.tintColor = .black
//        rabbitCheckMarkButton.tintColor = .black
//
////        if checked == currentButton {
////            sender.setImage(UIImage(systemName: "square"), for: .normal)
////            sender.tintColor = .black
////            currentButton = nil
////        } else {
//            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//            sender.tintColor = .systemOrange
//            currentButton = checked
////        }
//    }

///~3rd way
//init() {
//    buttons = [smallCheckMarkButton, mediumCheckMarkButton, largeCheckMarkButton]
//    for (index, button) in buttons.enumerated() {
//        button.tag = index + 1
//    }

//@objc func didTapCheckMark(_ sender: UIButton) {
//    guard let checked = CurrentChecked(rawValue: sender.tag) else {
//        return
//    }
//
////        for button in buttons {
////            if button == sender {
////                button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
////                button.tintColor = .systemOrange
////            } else {
////                button.setImage(UIImage(systemName: "square"), for: .normal)
////                button.tintColor = .black
////            }
////        }
////
////        if checked == currentButton {
////            sender.setImage(UIImage(systemName: "square"), for: .normal)
////            sender.tintColor = .black
////            currentButton = nil
////        } else {
////            currentButton = checked
////        }
//      allows deselecting a selected box [ optional ]
//    for button in buttons {
//        if button == sender {
//            if checked == currentButton {
//                button.setImage(UIImage(systemName: "square"), for: .normal)
//                button.tintColor = .black
//                currentButton = nil
//            } else {
//                button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//                button.tintColor = .systemOrange
//                currentButton = checked
//            }
//        } else {
//            button.setImage(UIImage(systemName: "square"), for: .normal)
//            button.tintColor = .black
//        }
//    }
//       doesnt allows deselect a selected box [ obligatory ]
//@objc func didTapCheckMark(_ sender: UIButton) {
//    guard let checked = CurrentChecked(rawValue: sender.tag) else {
//        return
//    }
//
//    for button in buttons {
//        if button == sender {
//                button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//                button.tintColor = .systemOrange
//                currentButton = checked
//        } else {
//            button.setImage(UIImage(systemName: "square"), for: .normal)
//            button.tintColor = .black
//            currentButton = checked
//        }
//    }
//}
//}

