//
//  UserData.swift
//  Volrota
//
//  Created by Greg Zenkov on 4/1/23.
//

import Foundation

struct UserData: Codable {
    
    let name: String
    let secondName: String
    let organizationId: String
    let profileImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case secondName = "second_name"
        case organizationId = "organization_id"
        case profileImageUrl = "image_url"
    }
}

struct Organization: Codable {
    
    let name: String
    let imageUrl: String
    let cityName: String
    let fullAddress: String
    let organizationId: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "image_url"
        case cityName = "city_name"
        case fullAddress = "full_address"
        case organizationId = "organization_id"
    }
}