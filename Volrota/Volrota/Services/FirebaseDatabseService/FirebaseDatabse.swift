//
//  FirebaseDatabse.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import Foundation
import FirebaseFirestore

protocol FirebaseDatabse {
    func detAdvertisments() async throws -> [MainViewController.MainViewControllerProps.NewsViewProps]
    func getEvents() async throws -> [MainViewController.MainViewControllerProps.EventViewProps]
}

final class DefaultFirebaseDatabse: FirebaseDatabse {
    
    private let database: Firestore
    
    init() {
        database = Firestore.firestore()
    }
    
    func detAdvertisments() async throws -> [MainViewController.MainViewControllerProps.NewsViewProps] {
        let documentRef = database.collection("volrota/global/ads")
        //documentRef.getDocuments { snap, error in
        do {
            let documents = try await documentRef.getDocuments().documents
            
            let ads = Converter.convertToAds(documents: documents)
            
            return ads
            
        } catch {
            throw error
        }
    }
    
    func getEvents() async throws -> [MainViewController.MainViewControllerProps.EventViewProps] {
        let documentRef = database.collection("volrota/global/events")
        
        do {
            
            let documents = try await documentRef.getDocuments().documents
            
            let events = Converter.convertToEvents(documents: documents)
            
            return events
            
        } catch {
            throw error
        }
    }
}

enum FirebaseError: Error {
    case fail
}

class Converter {
    
    static func convertToAds(
        documents: [QueryDocumentSnapshot]
    ) -> [MainViewController.MainViewControllerProps.NewsViewProps] {
        var ads = [MainViewController.MainViewControllerProps.NewsViewProps]()
        
        for document in documents {
            let ad = MainViewController.MainViewControllerProps.NewsViewProps(document.data())
            ads.append(ad)
        }
        
        return ads
    }
    
    static func convertToEvents(
        documents: [QueryDocumentSnapshot]
    ) -> [MainViewController.MainViewControllerProps.EventViewProps] {
        var events = [MainViewController.MainViewControllerProps.EventViewProps]()
        
        for document in documents {
            let event = MainViewController.MainViewControllerProps.EventViewProps(document.data())
            events.append(event)
        }
        
        return events
    }
}
