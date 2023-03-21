//
//  GlobalModel.swift
//  Volrota
//
//  Created by Greg Zenkov on 3/20/23.
//

import UIKit
import FirebaseFirestore

struct GlobalModel {
    
    let ads: [AdsModel]
    let events: [EventModel]
    let actuals: [ActualModel]
    
    struct AdsModel: CustomStringConvertible {
    
        let title: String
        let bannerTitle: String
        let viewBackgroundColor: UIColor
        let bannerBackgroundColor: UIColor
        let titleColor: UIColor
        let bannerTitleColor: UIColor
        
        var description: String {
            return title
        }
        
        init(_ dictionary: [String: Any]) {
            title = dictionary["title"] as? String ?? ""
            bannerTitle = dictionary["banner_title"] as? String ?? ""
            viewBackgroundColor = UIColor(dictionary["bg_color"] as? String ?? "")
            bannerBackgroundColor = UIColor(dictionary["banner_bg_color"] as? String ?? "")
            titleColor = UIColor(dictionary["title_color"] as? String ?? "")
            bannerTitleColor = UIColor(dictionary["banner_title_color"] as? String ?? "")
        }
    }
    
    struct EventModel: CustomStringConvertible {
        
        let eventTitle: String
        let eventImageURL: String
        let startDate: Timestamp
        let endDate: Timestamp
        let lat: Double
        let long: Double
        
        var description: String {
            return eventTitle
        }
        
        init(_ dictionary: [String: Any]) {
            eventTitle = dictionary["title"] as? String ?? ""
            eventImageURL = dictionary["image"] as? String ?? ""
            startDate = dictionary["start_date"] as? Timestamp ?? Timestamp()
            endDate = dictionary["end_date"] as? Timestamp ?? Timestamp()
            lat = dictionary["lat"] as? Double ?? 0.0
            long = dictionary["long"] as? Double ?? 0.0
        }
    }
    
    struct ActualModel: CustomStringConvertible {
        
        let title: String
        let imageUrl: String
        let descriptionText: String
        let cityName: String
        
        var description: String {
            return title
        }
        
        init(_ dictionary: [String: Any]) {
            title = dictionary["title"] as? String ?? ""
            imageUrl = dictionary["image_url"] as? String ?? ""
            descriptionText = dictionary["description"] as? String ?? ""
            cityName = dictionary["city_name"] as? String ?? ""
        }
    }
}
