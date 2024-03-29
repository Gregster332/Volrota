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

public protocol FirebaseDatabse {
    func getGlobalData() async throws -> GlobalModel
    func getEvents(_ dictionary: [String: Any]?) async throws -> [EventsModel.EventModel]
    func getActuals(_ dictionary: [String: Any]?) async throws -> [GlobalModel.ActualModel]
    func createNewUser(userId: String, name: String, organization: String, imageUrl: String?) async throws
    func getUserInfo(by id: String) async -> UserData?
    func updateUserPhotoUrl(with id: String, _ imageUrl: String) async throws
    func getOrganizationBy(_ id: String) async -> Organization?
    func getAllOrganizations() async throws -> [Organization]
    func updateUserEvents(with eventId: String, userId: String) async
    func updateUserName(with id: String,_ name: String) async throws
    func addNewEvent(_ eventModel: EventsModel.EventModel, with id: String) async throws
}

public final class DefaultFirebaseDatabse: FirebaseDatabse {
    
    private let database: Firestore
    
    public init() {
        database = Firestore.firestore()
    }
    
    // Методы протокола ...
    // Приватные методы сервиса ...
    
    public func getGlobalData() async throws -> GlobalModel {
        do {
            let ads = try await detAdvertisments()
            let actuals = try await getActuals(nil)
            
            //throw FirebaseError.fail
            
            return GlobalModel(ads: ads, actuals: actuals)
        } catch {
            throw error
        }
    }
    
    public func getEvents(_ dictionary: [String: Any]?) async throws -> [EventsModel.EventModel] {
        let ref = database.collection("volrota/global/events")
        
        do {
            
            var documents = [QueryDocumentSnapshot]()
            
            if let dictionary = dictionary {
                for (key, value) in dictionary {
                    documents = try await ref.whereField(key, isEqualTo: value).getDocuments().documents
                }
            } else {
                documents = try await ref.getDocuments().documents
            }
            
            let events = try documents.compactMap {
                try $0.data(as: EventsModel.EventModel.self)
            }
            
            return events
        } catch {
            throw error
        }
    }
    
    public func getActuals(_ dictionary: [String: Any]?) async throws -> [GlobalModel.ActualModel] {
        
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
    
    public func createNewUser(
        userId: String,
        name: String,
        organization: String,
        imageUrl: String?
    ) async throws {
        
        let collectionRef = database.collection("volrota/private/users")
        
        do {
            let document = collectionRef.document(userId)
            
            var data = [String: Any]()
            data["name"] = name
            data["organization_id"] = organization
            data["image_url"] = imageUrl ?? ""
            data["events_ids"] = [String]()
            try await document.setData(data)
        } catch {
            throw error
        }
        
    }
    
    public func updateUserPhotoUrl(with id: String, _ imageUrl: String) async throws {
        let collectionRef = database.collection("volrota/private/users")
        
        do {
            let documentRef = collectionRef.document(id)
            try await documentRef.updateData(["image_url" : imageUrl])
        } catch {
            throw error
        }
    }
    
    public func updateUserName(with id: String,_ name: String) async throws {
        let collectionRef = database.collection("volrota/private/users")
        
        do {
            let documentRef = collectionRef.document(id)
            try await documentRef.updateData(["name" : name])
        } catch {
            throw error
        }
    }
    
    public func getUserInfo(by id: String) async -> UserData? {
        let collectionRef = database.collection("volrota/private/users")
        let document = try? await collectionRef.document(id).getDocument()
        let user = try? document?.data(as: UserData.self)
        return user
    }
    
    public func getOrganizationBy(_ id: String) async -> Organization? {
        if id.isEmpty {
            return nil
        }
        let collection = database.collection("volrota/global/organizations")
        let document = try? await collection.document(id).getDocument()
        let organization = try? document?.data(as: Organization.self)
        return organization
    }
    
    public func getAllOrganizations() async throws -> [Organization] {
        
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
    
    public func updateUserEvents(with eventId: String, userId: String) async {
        let collectionRef = database.collection("volrota/private/users")
        let document = try? await collectionRef.document(userId).getDocument()
        
        var eventsIds = try? document?.data(as: UserData.self).eventsIds
        eventsIds?.append(eventId)
        try? await document?.reference.updateData(["events_ids": eventsIds])
    }
    
    public func addNewEvent(_ eventModel: EventsModel.EventModel, with id: String) async throws {
        let collectionRef = database.collection("volrota/global/events")
        let documentRef = collectionRef.document(id)
        
        do {
            var data = [String: Any]()
            data["title"] = eventModel.eventTitle
            data["image"] = eventModel.eventImageURL
            data["start_date"] = eventModel.startDate
            data["end_date"] = eventModel.endDate
            data["event_id"] = id
            data["lat"] = eventModel.lat
            data["long"] = eventModel.long
            try await documentRef.setData(data)
        } catch {
            throw error
        }
    }
}

public enum FirebaseError: Error {
    case fail
}
