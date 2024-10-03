//
//  LocalStorageService.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import Foundation

/// `LocalStorageService` is responsible for managing persistent storage for favorite venues.
/// It interacts with `UserDefaults` to store and retrieve venue IDs marked as favorites.
class LocalStorageService {
    private let favouritesKey = "favouriteVenues"
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func getFavouriteVenueIds() -> [String] {
        return userDefaults.array(forKey: favouritesKey) as? [String] ?? []
    }
 
    func setFavouriteVenueIds(_ ids: [String]) {
        userDefaults.set(ids, forKey: favouritesKey)
    }
    
    func isFavourite(id: String) -> Bool {
        return getFavouriteVenueIds().contains(id)
    }
}
