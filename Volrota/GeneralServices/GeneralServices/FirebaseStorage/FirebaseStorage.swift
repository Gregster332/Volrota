//
//  FirebaseStorage.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/2/23.
//

import FirebaseCore
import FirebaseStorage

public protocol FirebaseStorage {
    func uploadPhoto(with userId: String, name: String, image: UIImage) async throws -> String
}

public final class DefaultFirebaseStorage: FirebaseStorage {
    
    private let storage: StorageReference
    
    public init() {
        storage = Storage.storage().reference()
    }
    
    public func uploadPhoto(with userId: String, name: String, image: UIImage) async throws -> String {
        let ref = storage.child("\(userId).\(name).png")
        do {
            if let uploadData = image.pngData() {
                let metadata = try await ref.putDataAsync(uploadData)
                let url = try await ref.downloadURL()
                return url.absoluteString
            } else {
                throw FirebaseStorageError.badData
            }
        } catch {
            throw error
        }
    }
}

enum FirebaseStorageError: Error {
    case badData
}
