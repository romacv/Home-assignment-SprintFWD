//
//  Business.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 3/7/2022.
//

struct Business: Codable {
    let id, phone, alias, name, url, imageUrl: String
    let price: String?
    let reviewCount: Int
    let isClosed: Bool
    let distance, rating: Float
    let categories: [Category]
    let coordinates: Coordinates?
    let location: Location
    let transactions: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case price = "price"
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
