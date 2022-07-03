//
//  LocalService.swift
//  Home-assignment-SprintFWD
//
//  Created by Roman Resenchuk on 3/7/2022.
//

import Foundation

class LocalService {
    static let homeScreenStateKey = "HomeScreenState"
    
    static func saveHomeScreenState(index: Int) {
        UserDefaults.standard.set(index, forKey: homeScreenStateKey)
        UserDefaults.standard.synchronize()
    }
    
    static func fetchHomeSegmentedPosition() -> Int {
        return UserDefaults.standard.integer(forKey: homeScreenStateKey)
    }
}
