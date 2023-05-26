//
//  UserData.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/1/23.
//

import Foundation

// MARK: - UserData
public struct UserData: Codable {
    
    public let name: String
    public let organizationId: String
    public let profileImageUrl: String
    public let eventsIds: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case organizationId = "organization_id"
        case profileImageUrl = "image_url"
        case eventsIds = "events_ids"
    }
}

// MARK: - Organization
public struct Organization: Codable {
    
    public let name: String
    public let imageUrl: String
    public let cityName: String
    public let fullAddress: String
    public let organizationId: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "image_url"
        case cityName = "city_name"
        case fullAddress = "full_address"
        case organizationId = "organization_id"
    }
}
