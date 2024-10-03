//
//  MockLocalStorageService.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 03.10.2024.
//

import XCTest
@testable import VenuesLocator

final class MockLocalStorageService: LocalStorageService {
    var favouriteIds: [String] = []

    override func getFavouriteVenueIds() -> [String] {
        return favouriteIds
    }

    override func setFavouriteVenueIds(_ ids: [String]) {
        favouriteIds = ids
    }

    override func isFavourite(id: String) -> Bool {
        return favouriteIds.contains(id)
    }
}


