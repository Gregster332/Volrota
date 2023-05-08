//
//  GlobalModel.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import UIKit
import FirebaseFirestore

// MARK: - GlobalModel
public struct GlobalModel: Codable {
    
    public let ads: [AdsModel]
    public let actuals: [ActualModel]
    
    // MARK: - AdsModel
    public struct AdsModel: Codable {
    
        public let title: String
        public let bannerTitle: String
        public let viewBackgroundColor: String
        public let bannerBackgroundColor: String
        public let titleColor: String
        public let bannerTitleColor: String
        
        public enum CodingKeys: String, CodingKey {
            case title
            case bannerTitle = "banner_title"
            case viewBackgroundColor = "bg_color"
            case bannerBackgroundColor = "banner_bg_color"
            case titleColor = "title_color"
            case bannerTitleColor = "banner_title_color"
        }
    }
    
    // MARK: - ActualModel
    public struct ActualModel: Codable {
        
        public let title: String
        public let imageUrl: String
        public let descriptionText: String
        public let cityName: String
        
        public enum CodingKeys: String, CodingKey {
            case title
            case imageUrl = "image_url"
            case descriptionText = "description"
            case cityName = "city_name"
        }
    }
}

public struct EventsModel: Codable {
    public let events: [EventModel]
    
    // MARK: - EventModel
    public struct EventModel: Codable {
        
        public let eventTitle: String
        public let eventImageURL: String
        public let startDate: Timestamp
        public let endDate: Timestamp
        public let lat: Double
        public let long: Double
        public let eventId: String
        
        enum CodingKeys: String, CodingKey {
            case eventTitle = "title"
            case eventImageURL = "image"
            case startDate = "start_date"
            case endDate = "end_date"
            case eventId = "event_id"
            case lat
            case long
        }
    }
}
