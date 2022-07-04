//
//  MKPointAnnotation.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 4/7/2022.
//

import MapKit

extension MKPointAnnotation {
    struct Holder {
        static var _identifier: String = 0
    }
    var identifier: String {
        get {
            return Holder._identifier
        }
        set(newValue) {
            Holder._identifier = newValue
        }
    }
}
