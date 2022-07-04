//
//  DetailsVM.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 3/7/2022.
//

import MapKit

class DetailsVM {
    // MARK: - Properties
    var selectedBusiness: Business?
    var reloadedData: (() -> ()) = {}
    var showError: (() -> ()) = {}
    var userCoordinate: CLLocationCoordinate2D?
    var polyline: MKPolyline?
    
    func calculateRoot() {
        guard let coordinates = selectedBusiness?.coordinates,
              let latitude = coordinates.latitude,
              let longitude = coordinates.longitude,
        let userCoordinate = userCoordinate else {
            return
        }
        let request = MKDirections.Request()
        let sourceCoordinate = CLLocationCoordinate2D(latitude: userCoordinate.latitude,
                                                      longitude: userCoordinate.longitude)
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        request.source = MKMapItem(placemark: sourcePlacemark)
        let destCoordinate = CLLocationCoordinate2D(latitude: latitude,
                                                    longitude: longitude)
        let destPlacemark = MKPlacemark(coordinate: destCoordinate)
        request.destination = MKMapItem(placemark: destPlacemark)
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            if error != nil {
                self?.showError()
                return
            }
            guard let unwrappedResponse = response else {
                return
            }
            for route in unwrappedResponse.routes {
                self?.polyline = route.polyline
                self?.reloadedData()
            }
        }
    }
    
    
}
