//
//  APIService.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 3/7/2022.
//

import Foundation

struct APIService {
    static private let apiURL = "https://api.yelp.com/v3/"
    
    enum SortBy: String {
        case bestMatch = "best_match"
        case rating = "rating"
        case reviewCount = "review_count"
        case distance = "distance"
    }
    
    static func getBusinesses(latitude: Double,
                              longitude: Double,
                              radius: Int,
                              sortBy: APIService.SortBy,
                              categories: String,
                              completion: @escaping (Businesses?, Error?) -> ()) {
        let requestURLString = apiURL + "businesses/search"
        let queryItems = [URLQueryItem(name: "latitude", value: String(latitude)),
                          URLQueryItem(name: "longitude", value: String(longitude)),
                          URLQueryItem(name: "radius", value: String(radius)),
                          URLQueryItem(name: "sort_by", value: sortBy.rawValue),
                          URLQueryItem(name: "categories", value: String(categories))]
        var urlComps = URLComponents(string: requestURLString)!
        urlComps.queryItems = queryItems
        var request = URLRequest(url: urlComps.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(yelpAPIKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                print("===\nResponse getBusinesses: \n \(String(data: data, encoding: .utf8) ?? "")"
                      + "\n===")
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(Businesses.self, from: data)
                completion(empData, nil)
            }
        }.resume()
    }
    
}
