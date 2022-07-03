//
//  HomeVM.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 3/7/2022.
//

import Foundation

class HomeVM {
    // MARK: - Properties
    var reloadedData: (() -> ()) = {}
    var showError: (() -> ()) = {}
    private(set) var data: Businesses? {
        didSet {
            self.reloadedData()
        }
    }
    private(set) var error: Error? {
        didSet {
            self.showError()
        }
    }
    enum HomeScreenState: Int {
        case map
        case list
    }
    var latitude = 33.524155 // Default lat
    var longitude = -111.905792 // Default long
    
    // MARK: - Functionality
    func saveHomeScreenState(index: Int) {
        LocalService.saveHomeScreenState(index: index)
    }
    
    func homeScreenState() -> HomeScreenState {
        return HomeScreenState(rawValue: LocalService.fetchHomeSegmentedPosition()) ?? .map
    }
    
    func fetchBusinessesData() {
        let radius = 1000
        let sortBy = APIService.SortBy.distance
        let categories = "fitness"
        APIService.getBusinesses(latitude: latitude,
                                 longitude: longitude,
                                 radius: radius,
                                 sortBy: sortBy,
                                 categories: categories) { businesses, error in
            guard let businesses = businesses else {
                return
            }
            if let error = error {
                self.error = error
                self.showError()
                return
            }
            self.data = businesses
        }
    }
}
