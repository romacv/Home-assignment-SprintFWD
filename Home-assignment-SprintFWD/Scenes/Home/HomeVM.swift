//
//  HomeVM.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 3/7/2022.
//

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
    static let defaultLatitude = 33.524155
    static let defaultLongitude = -111.905792
    var latitude = defaultLatitude
    var longitude = defaultLongitude
    let locationService = LocationService()
    
    // MARK: - Functionality
    func saveHomeScreenState(index: Int) {
        StorageService.saveHomeScreenState(index: index)
    }
    
    func homeScreenState() -> HomeScreenState {
        return HomeScreenState(rawValue: StorageService.fetchHomeSegmentedPosition()) ?? .map
    }
    
    func fetchBusinessesData() {
        if latitude == Self.defaultLatitude ||
            longitude == Self.defaultLongitude {
            requestBusinessesData()
            locationService.fetchLocationWithCompletionHandler { [weak self] latitude, longitude in
                self?.latitude = latitude
                self?.longitude = longitude
                self?.requestBusinessesData()
            }
        }
        else {
            requestBusinessesData()
        }
    }
    
    private func requestBusinessesData() {
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
