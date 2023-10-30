//
//  ImageServiceMock.swift
//  pethugTests
//
//  Created by Raul Pena on 29/10/23.
//

import UIKit
import Combine
import FirebaseStorage
import FirebaseAuth

@testable import pethug

//MARK: - Success Mock
final class ImageServiceSuccessMock: ImageServiceProtocol {
    //MARK: - Uplaod
    func uploadImage(image: UIImage, path: String) async throws -> String? {
        let result = "\(path)"
        
        return result
    }
    
    //MARK: - Download
    func downloadImage(url: String, completion: @escaping (_ dataImage: Data?) -> Void) {
        let mockData = Data()
        
        completion(mockData)
    }
    
    //MARK: - Delete
    func deleteImages(imagesUrl: [String]) { }
}

//MARK: - Failure Mock
final class ImageServiceFailureMock: ImageServiceProtocol {
    //MARK: - Uplaod
    func uploadImage(image: UIImage, path: String) async throws -> String? {
        throw NSError(domain: "Error mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error occurred"])
    }
    
    //MARK: - Download
    func downloadImage(url: String, completion: @escaping (_ dataImage: Data?) -> Void) {
        completion(nil)
    }
    
    //MARK: - Delete
    func deleteImages(imagesUrl: [String]) { }
}
