//
//  UpdateFavouriteUseCase.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import Foundation

protocol UpdateFavouriteUseCaseProtocol {
    func execute(venue: Venue)
}

/// Implementation of `UpdateFavouriteUseCaseProtocol`.
/// Handles adding or removing a venue from the favorites list in local storage.
class UpdateFavouriteUseCase: UpdateFavouriteUseCaseProtocol {
    private var localStorageService: LocalStorageService
    
    init(localStorageService: LocalStorageService) {
        self.localStorageService = localStorageService
    }
    
    /// Executes the update favorite use case.
    /// Toggles the favorite state of the given venue.
    /// - Parameter venue: The `Venue` object whose favorite state is being toggled.
    func execute(venue: Venue) {
        var favouriteVenueIds = localStorageService.getFavouriteVenueIds()
        
        if let index = favouriteVenueIds.firstIndex(of: venue.id) {
            favouriteVenueIds.remove(at: index)
        } else {
            favouriteVenueIds.append(venue.id)
        }
        
        localStorageService.setFavouriteVenueIds(favouriteVenueIds)
    }
}
