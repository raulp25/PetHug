//
//  ImageUploadService.swift
//  pethug
//
//  Created by Raul Pena on 15/09/23.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
protocol ImageServiceProtocol {
    /// Uploads image and returns the url.
    /// - Parameters:
    ///   - image:
    /// - Returns url with type ``URL`` or ``Nil``
    func uploadImage(image: UIImage, path: String) async throws -> String?
    
    //Doesn't support async
    /// Downloads image and returns the data through completion handler.
    /// - Parameters:
    ///   - url:
    ///   - completion @escaping:
    /// - This function doesn't support async
    /// - Returns image with type ``Data`` or ``Nil``
    func downloadImage(url: String, completion: @escaping (Data?) -> Void)
}

final class ImageService: ImageServiceProtocol {

    func uploadImage(image: UIImage, path: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.78) else { return nil}
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        _ = try await ref.putDataAsync(imageData)
        
        let result = try await ref.downloadURL().absoluteString
        
        return result
    }
    
    func downloadImage(url: String, completion: @escaping (_ dataImage: Data?) -> Void) {
        Storage.storage().reference(forURL: url).getData(maxSize: 10 * 1024 * 1024) { dataImage, error in
            if let error = error?.localizedDescription {
                print("error retrieving data from Firebase Storage", error)
                completion(nil)
                return
            }
            
            completion(dataImage!)
        }
    }
}


