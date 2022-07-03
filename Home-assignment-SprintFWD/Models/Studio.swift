//
//  Studio.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 3/7/2022.
//

import Foundation

struct Businesses: Codable {
    let total: Int
    let businesses: [Business]
    let region: Region
}

struct Business: Codable {
    let id, phone, alias, name, url, imageUrl: String
    let price: String?
    let reviewCount: Int
    let isClosed: Bool
    let distance, rating: Double
    let categories: [Category]
    let coordinates: Coordinates
    let location: Location
    let transactions: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case price
        case phone
        case alias
        case name
        case url
        case imageUrl = "image_url"
        case rating
        case reviewCount = "review_count"
        case isClosed = "is_closed"
        case distance
        case categories
        case coordinates
        case location
        case transactions
    }
}

struct Region: Codable {
    let center: Coordinates
}

struct Category: Codable {
    let alias, title: String
}

struct Coordinates: Codable {
    let latitude, longitude: Double
}

struct Location: Codable {
    let city, country, address1, address2, address3, state, zip_code: String?
}
