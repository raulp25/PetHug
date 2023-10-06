//
//  Commentaries.swift
//  pethug
//
//  Created by Raul Pena on 24/09/23.
//

import Foundation


///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//MARK: - DiffableDataSoruce

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

/////~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

///~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

///~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
///~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
///~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
///~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///GENERAL
//////~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
///quick appending
//Append states from case and init
///    func generatePetBreeds(total: Int) -> [Item] {
//var addresses = [Item]()
////        for number in 0...total {
////            let k = Int(arc4random_uniform(6))
////            addresses.append(.title(.init(address: "Queretaro")))
////        }
////
//let estadosMexicanos = [
//    "Aguascalientes",
//    "Baja California",
//    "Baja California Sur",
//    "Campeche",
//    "Chiapas",
//    "Chihuahua",
//    "Coahuila",
//    "Colima",
//    "Durango",
//    "Guanajuato",
//    "Guerrero",
//    "Hidalgo",
//    "Jalisco",
//    "Estado de México",
//    "Michoacán",
//    "Morelos",
//    "Nayarit",
//    "Nuevo León",
//    "Oaxaca",
//    "Puebla",
//    "Querétaro",
//    "Quintana Roo",
//    "San Luis Potosí",
//    "Sinaloa",
//    "Sonora",
//    "Tabasco",
//    "Tamaulipas",
//    "Tlaxcala",
//    "Veracruz",
//    "Yucatán",
//    "Zacatecas"
//]
//
//
//for estado in estadosMexicanos {
//    addresses.append(.title(.init(address: estado)))
//}
//
//
//return addresses
//}
//
///~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
///text validation with prefix
//if text.count > 1 && text.hasPrefix("0") {
//    let text = String(text.dropFirst())
//    textField.text = text
//    currentConfiguration.viewModel?.delegate?.activityLevelChanged(to: Int(text))
//
//}

///~~~~~~~~~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
///Decoding / encoding
//func mockDecodePetModel() {
//    print("corre mock pet model decode 789: => ")
//    let petModel: PetModel = PetModel(id: "3323-ews3", name: "Joanna Camacho", age: 22, gender: "female", size: "small", breed: "Dachshund", imagesUrls: ["firebase.com/ImageExampleMyCousin"], type: "dog", address: "Sinaloa", isLiked: false)
//
//    let petModelData: [String: Any] = [
//        "id": "3323-ews3",
//        "name": "Joanna Camacho",
//        "age": 22,
//        "gender": "female",
//        "size": "small",
//        "breed": "Dachshund",
//        "imagesUrls": ["firebase.com/ImageExampleMyCousin"],
//        "type": "dog",
//        "address": "Sinaloa",
//        "isLiked": false
//    ]
//
//    if let jsonData = try? JSONSerialization.data(withJSONObject: petModelData, options: []) {
//
//        print("JSON DATA 335: => \(jsonData)")
//        let pet = try? JSONDecoder().decode(Pet.self, from: jsonData)
//        print("DECODE JSON DATA 335: => \(pet?.type)")
//
//    }

       ////this below doesnt work
//    let data  = try? JSONEncoder().encode(petModel)
//
//    print("JSON ENCODER DIFFERENT FROM SEARILIZATION 335: => \(data)")
////        if let jsonData = try? JSONEncoder().encode(petModel){
////            let pet = try? JSONDecoder().decode(Pet.self, from: jsonData)
////             // You now have a Pet instance with enum properties properly converted
////             // ...
////
////        }
//
//}

///~~~~~~~~~~~~~~~~~~~~~~~
///Deecode from Firebase or other source

///Both approaches work decoding with the data(as: ) function or
///custom encoding to json and decoding with decoder init.
/// Swift is able to recognize the types after decoding with both approaches
/// trough pattern matching
//func fetchPets(fetchCollection path: String) async throws -> [Pet] {
//    ///Usar mapper para transformar los docs
//    let snapshot = try await db.collection(path).getDocuments()
//    let docs = snapshot.documents
//
//    var pets = [Pet]()
//    for doc in docs {
//        let mappedPet = try doc.data(as: Pet.self)
//
//        pets.append(mappedPet)
//    }
//    for doc in docs {
//            let petModelData: [String: Any] = [
//                "id": "3323-ews3",
//                "name": "Joanna Camacho",
//                "age": 22,
//                "gender": "female",
//                "size": "small",
//                "breed": "Dachshund",
//                "imagesUrls": ["firebase.com/ImageExampleMyCousin"],
//                "type": "dog",
//                "address": "Sinaloa",
//                "isLiked": false
//            ]
//            let m = petModelData
//            if let jsonData = try? JSONSerialization.data(withJSONObject: m, options: []) {
//                let pet = try? JSONDecoder().decode(Pet.self, from: jsonData)
//                print("data firebase niga PET IN CUSTOM DECODER firebase JSONDATA: => \(jsonData)")
//                if let pet = pet {
//                    pets.append(pet)
//                    print("data firebase niga PET IN CUSTOM DECODER firebase fn: => \(pet.address)")
//                }
//
//            }
        
//            let petModelData: [String: Any] = [
//                "id": "3323-ews3",
//                "name": "Joanna Camacho",
//                "age": 22,
//                "gender": "female",
//                "size": "small",
//                "breed": "Dachshund",
//                "imagesUrls": ["firebase.com/ImageExampleMyCousin"],
//                "type": "dog",
//                "address": "Sinaloa",
//                "isLiked": false
//            ]
//
//            if let jsonData = try? JSONSerialization.data(withJSONObject: petModelData, options: []) {
//                let pet = try? JSONDecoder().decode(Pet.self, from: jsonData)
//
//                print("data firebase niga PET IN CUSTOM DECODER: => \(pet!.address)")
//
//                pets.append(pet!)
//            }
//
    
//
//            if let jsonData = try? JSONSerialization.data(withJSONObject: doc.data(), options: []) {
//                let pet = try? JSONDecoder().decode(Pet.self, from: jsonData)
//                if let pet = pet {
//                    pets.append(pet)
//                }
//            }
//    }
//
//    return pets
//}
///Trash but usefull for boilerplate on early stages of projects
//    private func createMockPet() {
//        let pet: Pet = .init(id: "552-omega", name: "Doli", age: 4, gender: .male, size: .large, breed: "labrador", imagesUrls: [], type: .dog, address: .MexicoCity, isLiked: false)
//        let db = Firestore.firestore()
//        Task {
//            do {
//                try db.collection(.getPath(for: .dogs)).document(pet.id).setData(from: pet)
//            } catch {
//
//            }
//        }
//    }
    
    
    
//    private func createMockPet() {
//        let pet: Pet = .init(id: "552-omega", name: "Doli", age: 4, gender: "f", size: "xl", breed: "labrador", imageUrl: "km", type: .dog(.goldenRetriever))
//        let data = pet.toObjectLiteral()
//        let db = Firestore.firestore()
//        Task {
//            do {
//
//                print("creating mock pet: => \(pet)")
//                let encoder = JSONEncoder()
//                      let data2 = try encoder.encode(pet)
//
//                if let petDictionary = try JSONSerialization.jsonObject(with: data2, options: []) as? [String: Any] {
//                    print(": mock pet dictionary => \(petDictionary)")
////                    try await db.collection(.getPath(for: .dogs)).document(pet.id).setData(petDictionary)
//                    ///Instead of enconding manually we use setData(from: [our data structure])
//                    try db.collection(.getPath(for: .dogs)).document(pet.id).setData(from: pet)
//                    print("data en fetch pets(): => \(data)")
//                }
//
//            } catch {
//
//            }
//        }
//    }
    
//    private func fetchPet() {
//        let db = Firestore.firestore()
//
//        db.collection(.getPath(for: .dogs)).document("332-alpha").getDocument { (document, error) in
//            if let document = document, document.exists {
//                do {
//                    if let data = document.data() {
//                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
//                        let decoder = JSONDecoder()
//                        let pet = try decoder.decode(Pet.self, from: jsonData)
//                        print("Fetched pet: => \(pet)")
//                    }
//                } catch {
//                    print("Error decoding pet: \(error)")
//                }
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }

//}


///~~~==========================================================
///CONCURRENCY

///~~~~~~~~~~~~~~~~~~~~~~~
////DOWNLOAD IMAGES FROM FIREBASE IN SEQUENCE Recursive approach // -DispatchGroup works for asyncrony but it wont respect the concurrency on items position
///func getImages(stringUrlArray: [String], completion: @escaping([UIImage]) -> Void) {
//if !imagesToEdit.isEmpty, let imageService = imageService {
//    var images = [UIImage]()
////
////            let group = DispatchGroup()
////
////            for imageUrl in imagesToEdit {
////                group.enter()
////                imageService.downloadImage(url: imageUrl) { imageData in
////                    print("image data adentro de for sera nil? cell registration: : => \(imageData)")
////                    if let imageData = imageData,
////                       let image = UIImage(data: imageData)
////                    {
////                        images.append(image)
////                        group.leave()
////                    }
////                }
////            }
////
////            group.notify(queue: .main) {
////                completion(images)
////            }
//
//    func downloadNextImage(index: Int) {
//           if index >= stringUrlArray.count {
//               // All downloads are complete, call the completion handler
//               completion(images)
//           } else {
//               let imageUrl = stringUrlArray[index]
//               imageService.downloadImage(url: imageUrl) { imageData in
//                   if let imageData = imageData, let image = UIImage(data: imageData) {
//                       images.append(image)
//                   }
//                   // Move on to the next image download
//                   downloadNextImage(index: index + 1)
//               }
//           }
//       }
//
//       // Start the sequential downloads with the first image
//       downloadNextImage(index: 0)
//
//}
//}
//}

///~~~~~~~~~~~~~~~~~~~~~~~
///WithThrowingTaskGroup usef
//
/// func createPet() async {
//
//    stateSubject.send(.loading)
//
//    do {
//        var imagesUrls = [String]()
//
//        try await withThrowingTaskGroup(of: String.self, body: { group in
//
//            for image in galleryState {
//                group.addTask { try await self.imageService.uploadImage(image: image, path: .getStoragePath(for: .petProfile)) ?? "" }
//
////                    let imageUrl = try await imageService.uploadImage(image: image, path: .getStoragePath(for: .petProfile))
//
////                    if let imageUrl = imageUrl {
////                        imagesUrls.append(imageUrl)
////                    }
//
//                for try await image in group {
//                    if !image.isEmpty {
//                        imagesUrls.append(image)
//                    }
//                }
//
//            }
//
//        })
//
//        let pet = Pet(
//            id: UUID().uuidString,
//            name: nameState!,
//            gender: genderState,
//            size: sizeState,
//            breed: breedsState!,
//            imagesUrls: imagesUrls,
//            type: typeState!,
//            age: ageState!,
//            activityLevel: activityState!,
//            socialLevel: socialState!,
//            affectionLevel: affectionState!,
//            address: addressState!,
//            info: infoState!,
//            isLiked: false,
//            timestamp: Timestamp(date: Date())
//        )
//
//
//        let _ = try await createPet(pet: pet)
//
//        stateSubject.send(.success)
//
//    } catch {
//        stateSubject.send(.error(.default(error)))
//    }


///~~~==========================================================
///PARSER ENCODE DECODE CODABLE

///Custom parser class
//Request manager swft mrvl
//protocol DataParser {
//    func parse<T: Decodable>(data: Data) throws -> T
//}
//
//class DefaultDataParser: DataParser {
//    private var jsonDecoder: JSONDecoder
//    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
//        self.jsonDecoder = jsonDecoder
//    }
//    func parse<T: Decodable>(data: Data) throws -> T {
//        return try jsonDecoder.decode(T.self, from: data)
//    }
//}



//
//  NewPetViewModel.swift
//  pethug
//
//  Created by Raul Pena on 01/10/23.
//

//import UIKit
//import Firebase
//import Combine
//
//class NewPetViewModel {
//    //MARK: - Private properties
//    private let imageService: ImageServiceProtocol
//    private let createPetUseCase: DefaultCreatePetUC
//    private let updatePetUseCase: DefaultUpdatePetUC
//
//    //MARK: - Internal Properties
//    private var pet: Pet?
//    init(imageService: ImageServiceProtocol, createPetUseCase: DefaultCreatePetUC, updatePetUseCase: DefaultUpdatePetUC) {
//        self.imageService = imageService
//        self.createPetUseCase = createPetUseCase
//        self.updatePetUseCase = updatePetUseCase
//        observeValidation()
//
////        mockDecodePetModel()
//    }
//
//    init(imageService: ImageServiceProtocol, createPetUseCase: DefaultCreatePetUC, updatePetUseCase: DefaultUpdatePetUC, pet: Pet? = nil) {
//        print("recibio pet en newpet view model 444 : => \(String(describing: pet?.imagesUrls))")
//        self.imageService = imageService
//        self.createPetUseCase = createPetUseCase
//        self.updatePetUseCase = updatePetUseCase
//        self.pet = pet
//        self.isEdit = true
//        observeValidation()
////        let imagesArr = getImages(stringUrlArray: pet?.imagesUrls ?? [])
//        self.imagesToEditState = pet?.imagesUrls ?? []
//
//        self.nameState = pet?.name
//        self.galleryState = []
//        self.typeState = pet?.type
//        self.breedsState = pet?.breed
//        self.genderState = pet?.gender
//        self.sizeState = pet?.size
//        self.ageState = pet?.age
//        self.activityState = pet?.activityLevel
//        self.socialState = pet?.socialLevel
//        self.affectionState = pet?.affectionLevel
//        self.addressState = pet?.address
//        self.infoState = pet?.info
//
////        mockDecodePetModel()
//    }
//
////    func mockDecodePetModel() {
////        print("corre mock pet model decode 789: => ")
////        let petModel: PetModel = PetModel(id: "3323-ews3", name: "Joanna Camacho", age: 22, gender: "female", size: "small", breed: "Dachshund", imagesUrls: ["firebase.com/ImageExampleMyCousin"], type: "dog", address: "Sinaloa", isLiked: false)
////
////        let petModelData: [String: Any] = [
////            "id": "3323-ews3",
////            "name": "Joanna Camacho",
////            "age": 22,
////            "gender": "female",
////            "size": "small",
////            "breed": "Dachshund",
////            "imagesUrls": ["firebase.com/ImageExampleMyCousin"],
////            "type": "dog",
////            "address": "Sinaloa",
////            "isLiked": false
////        ]
////
////        if let jsonData = try? JSONSerialization.data(withJSONObject: petModelData, options: []) {
////            let pet = try? JSONDecoder().decode(Pet.self, from: jsonData)
////
////            print("data firebase niga PET IN CUSTOM DECODER: => \(pet?.address)")
////        }
////
////    }
//
//    //MARK: - Form Validation
//    private var cancellables = Set<AnyCancellable>()
//
//    @Published var nameState:     String? = nil
//    @Published var galleryState:  [UIImage] = []
//    @Published var typeState:     Pet.PetType? = nil
//    @Published var breedsState:   String? = nil
//    @Published var genderState:   Pet.Gender? = nil
//    @Published var sizeState:     Pet.Size? = nil
//    @Published var ageState:      Int? = nil
//    @Published var activityState: Int? = nil
//    @Published var socialState:   Int? = nil
//    @Published var affectionState: Int? = nil
//    @Published var addressState:  Pet.State? = nil
//    @Published var infoState:     String? = nil
//
//    var imagesToEditState: [String] = []
//    var isEdit = false
//    var isValidSubject = CurrentValueSubject<Bool, Never>(false)
//    var stateSubject = PassthroughSubject<LoadingState, Never>()
//
//    func observeValidation() {
//            formValidationState.sink(receiveValue: { state in
//                switch state {
//                case .valid:
//                    self.isValidSubject.send(true)
//                    print("is valid 666")
//                case .invalid:
//                            print("is inValid 666")
//                    self.isValidSubject.send(false)
//                }
//            }).store(in: &cancellables)
//    }
//
//    var formValidationState: AnyPublisher<State, Never> {
//        return Publishers.CombineLatest4(
//            Publishers.CombineLatest3($nameState, $galleryState, $typeState),
//            Publishers.CombineLatest3($breedsState, $genderState, $sizeState),
//            Publishers.CombineLatest4($ageState, $activityState, $socialState, $affectionState),
//            Publishers.CombineLatest($addressState, $infoState)
//        )
//        .map { nameGalleryType, breedGenderSize, petStats, addressInfo in
//            let (name, gallery, type) = nameGalleryType
//            let (breed, gender, size) = breedGenderSize
//            let (age, activity, social, affection) = petStats
//            let (address, info) =  addressInfo
//
//            return self.validateForm(
//                name: name,
//                gallery: gallery,
//                type: type,
//                breed: breed,
//                gender: gender,
//                size: size,
//                age: age,
//                activity: activity,
//                social: social,
//                affection: affection,
//                address: address,
//                info: info
//            )
//
//        }
//        .eraseToAnyPublisher()
//    }
//
//    func validateForm(
//        name: String?,
//        gallery: [UIImage],
//        type: Pet.PetType?,
//        breed: String?,
//        gender: Pet.Gender?,
//        size: Pet.Size?,
//        age: Int?,
//        activity: Int?,
//        social: Int?,
//        affection: Int?,
//        address: Pet.State?,
//        info: String?
//    ) -> State{
//        //gender and size are optional for the user
////        print("name level en viewmodel: => 666 \(name)")
////        print("gallery level en viewmodel: => 221 \(gallery)")
////        print("gallery level is empty? en viewmodel: => 221 \(gallery.isEmpty)")
////        print("type level en viewmodel: => 666 \(type)")
////        print("breed level en viewmodel: => 666 \(breed)")
////        print("age level en viewmodel: => 666 \(age)")
////        print("activity level en viewmodel: => 221 \(activity)")
////        print("social level en viewmodel: => 666 \(social)")
////        print("affection level en viewmodel: => 666 \(affection)")
////        print("address level en viewmodel: => 666 \(address)")
////        print("info level en viewmodel: => 666 \(info)")
////        print("gender en viewmodel: => 666 \(gender)")
//
////       gender and size props are optional
//        if name == nil      ||
//           gallery.isEmpty  ||
//           type == nil      ||
//           breed == nil     ||
//           age == nil       ||
//           activity == nil  ||
//           social == nil    ||
//           affection == nil ||
//           address == nil   ||
//           info == nil {
//           return .invalid
//        }
//
//        return .valid
//    }
//
//    //MARK: - Upload new pet
//    func createPet() async {
//        print("emtra a createPet: => ")
//        stateSubject.send(.loading)
//
//        do {
//            var imagesUrls = [String]()
//
//           try await uploadNextImage(index: 0, imagesUrls: &imagesUrls)
//
//            let pet = Pet(
//                id: UUID().uuidString,
//                name: nameState!,
//                gender: genderState,
//                size: sizeState,
//                breed: breedsState!,
//                imagesUrls: imagesUrls,
//                type: typeState!,
//                age: ageState!,
//                activityLevel: activityState!,
//                socialLevel: socialState!,
//                affectionLevel: affectionState!,
//                address: addressState!,
//                info: infoState!,
//                isLiked: false,
//                timestamp: Timestamp(date: Date())
//            )
//
//
//            let _ = try await executeCreatePet(pet: pet)
//
//            stateSubject.send(.success)
//
//        } catch {
//            print("error en viewmodel 741: => ")
//            stateSubject.send(.error(.default(error)))
//        }
//
//    }
//
//    private func executeCreatePet(pet: Pet) async throws -> Bool{
//        let path = pet.type.getPath
//        print("entra a execute 741: =")
//        return try await createPetUseCase.execute(collection: path, data: pet)
//    }
//
//    func updatePet() async {
//
//        stateSubject.send(.loading)
//
//        do {
//            var imagesUrls = [String]()
//
//            try await uploadNextImage(index: 0, imagesUrls: &imagesUrls)
//            guard let currentPet = pet else { return }
//            let pet = Pet(
//                id: currentPet.id,
//                name: nameState!,
//                gender: genderState,
//                size: sizeState,
//                breed: breedsState!,
//                imagesUrls: imagesUrls,
//                type: typeState!,
//                age: ageState!,
//                activityLevel: activityState!,
//                socialLevel: socialState!,
//                affectionLevel: affectionState!,
//                address: addressState!,
//                info: infoState!,
//                isLiked: currentPet.isLiked,
//                timestamp: currentPet.timestamp
//            )
//
//
//            let _ = try await executeUpdatePet(pet: pet)
//
//            imageService.deleteImages(imagesUrl: currentPet.imagesUrls)
//
//            stateSubject.send(.success)
//
//        } catch {
//            stateSubject.send(.error(.default(error)))
//        }
//
//    }
//
//    private func executeUpdatePet(pet: Pet) async throws -> Bool{
//        let path = pet.type.getPath
//
//        return try await updatePetUseCase.execute(collection: path, data: pet)
//    }
//
//
//    func uploadNextImage(index: Int, imagesUrls: inout [String]) async throws {
//        guard let typeState = typeState else { return }
//        let path = typeState.storagePath
//
//        if index >= galleryState.count {
//            // end of recursive iteration
//        } else {
//            let image = galleryState[index]
//
////            do {
//                let imageUrl = try await imageService.uploadImage(image: image, path: path)
//                if let  imageUrl = imageUrl {
//                    imagesUrls.append(imageUrl)
//                }
//               try await uploadNextImage(index: index + 1, imagesUrls: &imagesUrls)
//
////            } catch {
////
////            }
//        }
//    }
//
//}
//
//
