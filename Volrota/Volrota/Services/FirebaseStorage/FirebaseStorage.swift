//
//  FirebaseStorage.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/2/23.
//

import FirebaseCore
import FirebaseStorage

protocol FirebaseStorage {
    func uploadPhoto(with userId: String, name: String, image: UIImage) async throws -> String
}

final class DefaultFirebaseStorage: FirebaseStorage {
    
    private let storage: StorageReference
    
    init() {
        storage = Storage.storage().reference()
    }
    
    func uploadPhoto(with userId: String, name: String, image: UIImage) async throws -> String {
        let ref = storage.child("\(userId).\(name).png")
        do {
            if let uploadData = image.pngData() {
                let metadata = try await ref.putDataAsync(uploadData)
                print(metadata)
                
                let url = try await ref.downloadURL()
                return url.absoluteString
            }
        } catch {
            throw error
        }
        return ""
    }
}
