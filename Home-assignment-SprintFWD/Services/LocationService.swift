//
//  LocationService.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 3/7/2022.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    static let shared = LocationService()
    
    let locationManager = CLLocationManager()
    var locationManagerCallback: ((_ latitude:Double, _ longitude:Double) -> ())?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    private func start() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchLocationWithCompletionHandler(completion: @escaping(_ latitude: Double, _ longitude:Double) -> ()) -> Void {
        locationManagerCallback = completion
        start()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        locationManagerCallback?(lastLocation.coordinate.latitude,
                                 lastLocation.coordinate.longitude)
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}
