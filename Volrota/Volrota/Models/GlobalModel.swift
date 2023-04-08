//
//  GlobalModel.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import UIKit
import FirebaseFirestore

// MARK: - GlobalModel
struct GlobalModel: Codable {
    
    let ads: [AdsModel]
    let events: [EventModel]
    let actuals: [ActualModel]
    
    // MARK: - AdsModel
    struct AdsModel: Codable {
    
        let title: String
        let bannerTitle: String
        let viewBackgroundColor: String
        let bannerBackgroundColor: String
        let titleColor: String
        let bannerTitleColor: String
        
        enum CodingKeys: String, CodingKey {
            case title
            case bannerTitle = "banner_title"
            case viewBackgroundColor = "bg_color"
            case bannerBackgroundColor = "banner_bg_color"
            case titleColor = "title_color"
            case bannerTitleColor = "banner_title_color"
        }
    }
    
    // MARK: - EventModel
    struct EventModel: Codable {
        
        let eventTitle: String
        let eventImageURL: String
        let startDate: Timestamp
        let endDate: Timestamp
        let lat: Double
        let long: Double
        
        enum CodingKeys: String, CodingKey {
            case eventTitle = "title"
            case eventImageURL = "image"
            case startDate = "start_date"
            case endDate = "end_date"
            case lat
            case long
        }
    }
    
    // MARK: - ActualModel
    struct ActualModel: Codable {
        
        let title: String
        let imageUrl: String
        let descriptionText: String
        let cityName: String
        
        enum CodingKeys: String, CodingKey {
            case title
            case imageUrl = "image_url"
            case descriptionText = "description"
            case cityName = "city_name"
        }
    }
}
