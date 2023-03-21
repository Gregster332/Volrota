//
//  FirebaseDatabse.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import Foundation
import FirebaseFirestore

protocol FirebaseDatabse {
    func getGlobalData() async throws -> GlobalModel
    func getEvents() async throws -> [GlobalModel.EventModel]
    func getActuals(_ dictionary: [String: Any]?) async throws -> [GlobalModel.ActualModel]
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
        let documentRef = database.collection("volrota/global/events")
        
        do {
            
            let documents = try await documentRef.getDocuments().documents
            
            let events = Converter.convertToEvents(documents: documents)
            
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
            
            let actuals = Converter.convertToActuals(documents: documents)
            
            return actuals
            
        } catch {
            throw error
        }
    }
    
    private func detAdvertisments() async throws -> [GlobalModel.AdsModel] {
        let documentRef = database.collection("volrota/global/ads")
        
        do {
            let documents = try await documentRef.getDocuments().documents
            
            let ads = Converter.convertToAds(documents: documents)
            
            return ads
            
        } catch {
            throw error
        }
    }
}

enum FirebaseError: Error {
    case fail
}

class Converter {
    
    static func convertToAds(documents: [QueryDocumentSnapshot]) -> [GlobalModel.AdsModel] {
        var ads = [GlobalModel.AdsModel]()
        
        for document in documents {
            let ad = GlobalModel.AdsModel(document.data())
            ads.append(ad)
        }
        
        return ads
    }
    
    static func convertToEvents(documents: [QueryDocumentSnapshot]) -> [GlobalModel.EventModel] {
        var events = [GlobalModel.EventModel]()
        
        for document in documents {
            let event = GlobalModel.EventModel(document.data())
            events.append(event)
        }
        
        return events
    }
    
    static func convertToActuals(documents: [QueryDocumentSnapshot]) -> [GlobalModel.ActualModel] {
        var actuals = [GlobalModel.ActualModel]()
        
        for document in documents {
            let actual = GlobalModel.ActualModel(document.data())
            actuals.append(actual)
        }
        
        return actuals
    }
}
