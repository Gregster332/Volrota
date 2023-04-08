//
//  FirebaseDatabse.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

protocol FirebaseDatabse {
    func getGlobalData() async throws -> GlobalModel
    func getEvents() async throws -> [GlobalModel.EventModel]
    func getActuals(_ dictionary: [String: Any]?) async throws -> [GlobalModel.ActualModel]
    func createNewUser(userId: String, name: String, secondName: String, organization: String) async throws
    func getUserInfo(by id: String) async throws -> UserData
    func updateUserPhotoUrl(with id: String, _ imageUrl: String) async throws
    func getOrganizationBy(_ id: String) async throws -> Organization
    func getAllOrganizations() async throws -> [Organization]
}

final class DefaultFirebaseDatabse: FirebaseDatabse {
    
    private let database: Firestore
    
    init() {
        database = Firestore.firestore()
    }
    
    func getGlobalData() async throws -> GlobalModel {
        do {
            let ads = try await detAdvertisments()
            let events = try await getEvents()
            let actuals = try await getActuals(nil)
            return GlobalModel(ads: ads, events: events, actuals: actuals)
        } catch {
            throw error
        }
    }
    
    func getEvents() async throws -> [GlobalModel.EventModel] {
        let ref = database.collection("volrota/global/events")
        
        do {
            
            let documentsRef = try await ref.getDocuments().documents
            let events = try documentsRef.compactMap {
                try $0.data(as: GlobalModel.EventModel.self)
            }
            
            return events
        } catch {
            throw error
        }
    }
    
    func getActuals(_ dictionary: [String: Any]?) async throws -> [GlobalModel.ActualModel] {
        
        let documentRef = database.collection("volrota/global/actuals")
        
        do {
            
            var documents = [QueryDocumentSnapshot]()
            
            if let dictionary = dictionary {
                for (key, value) in dictionary {
                    documents = try await documentRef.whereField(key, isEqualTo: value).getDocuments().documents
                }
            } else {
                documents = try await documentRef.getDocuments().documents
            }
            
            let actuals = try documents.compactMap {
                try $0.data(as: GlobalModel.ActualModel.self)
            }
            
            return actuals
            
        } catch {
            throw error
        }
    }
    
    func createNewUser(
        userId: String,
        name: String,
        secondName: String,
        organization: String
    ) async throws {
        
        let collectionRef = database.collection("volrota/private/users")
        
        do {
            let document = collectionRef.document(userId)
            
            var data = [String: Any]()
            data["name"] = name
            data["second_name"] = secondName
            data["organization_id"] = organization
            data["image_url"] = ""
            try await document.setData(data)
        } catch {
            throw error
        }
        
    }
    
    func updateUserPhotoUrl(with id: String, _ imageUrl: String) async throws {
        
        let collectionRef = database.collection("volrota/private/users")
        
        do {
            let documentRef = collectionRef.document(id)
            try await documentRef.updateData(["image_url" : imageUrl])
        } catch {
            throw error
        }
        
    }
    
    func getUserInfo(by id: String) async throws -> UserData {
        let collectionRef = database.collection("volrota/private/users")
        
        do {
            let document = try await collectionRef.document(id).getDocument()
            let user = try document.data(as: UserData.self)
            return user
        } catch {
            throw error
        }
    }
    
    func getOrganizationBy(_ id: String) async throws -> Organization {
        
        let collection = database.collection("volrota/global/organizations")
        
        do {
            let document = try await collection.document(id).getDocument()
            let organization = try document.data(as: Organization.self)
            return organization
        } catch {
            throw error
        }
    }
    
    func getAllOrganizations() async throws -> [Organization] {
        
        let collection = database.collection("volrota/global/organizations")
        
        do {
            let documents = try await collection.getDocuments().documents
            let organizations = try documents.compactMap {
                try $0.data(as: Organization.self)
            }
            return organizations
        } catch {
            throw error
        }
    }
    
    private func detAdvertisments() async throws -> [GlobalModel.AdsModel] {
        let documentRef = database.collection("volrota/global/ads")
        
        do {
            let documents = try await documentRef.getDocuments().documents
            
            let ads = try documents.compactMap {
                try $0.data(as: GlobalModel.AdsModel.self)
            }
            
            return ads
            
        } catch {
            throw error
        }
    }
}

enum FirebaseError: Error {
    case fail
}
