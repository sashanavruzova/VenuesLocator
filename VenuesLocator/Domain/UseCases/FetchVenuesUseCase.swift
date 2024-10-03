//
//  FetchVenuesUseCase.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import Foundation

protocol FetchVenuesUseCaseProtocol {
    func execute(latitude: Double, longitude: Double, completion: @escaping (Result<[Venue], Error>) -> Void)
}

/// Implementation of `FetchVenuesUseCaseProtocol`.
/// Handles fetching the venues from the API and updating their favorite state.
class FetchVenuesUseCase: FetchVenuesUseCaseProtocol {
    private let venueAPI: VenueAPI
    private let localStorageService: LocalStorageService

    init(venueAPI: VenueAPI, localStorageService: LocalStorageService) {
        self.venueAPI = venueAPI
        self.localStorageService = localStorageService
    }
    
    /// Executes the fetch venues use case.
    /// - Parameters:
    ///   - latitude: Latitude of the location for fetching venues.
    ///   - longitude: Longitude of the location for fetching venues.
    ///   - completion: Completion handler returning either a list of `Venue` objects or an `Error`.
    func execute(latitude: Double, longitude: Double, completion: @escaping (Result<[Venue], Error>) -> Void) {
        venueAPI.fetchVenues(latitude: latitude, longitude: longitude) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let venueResponse):
                let venues = self.getFirstVenues(with: venueResponse)
                let updatedVenues = self.updateFavouriteState(for: venues)
                completion(.success(Array(updatedVenues)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Gets the first 15 venues from the given response.
    /// - Parameter venueResponse: The response object containing venue sections.
    /// - Returns: An array of up to 15 `Venue` objects.
    private func getFirstVenues(with venueResponse: VenueResponse) -> [Venue] {
        venueResponse.sections.flatMap { $0.items.prefix(15).compactMap { $0.venue } }
    }
    
    /// Updates the favorite state for the given venues by checking local storage.
    /// - Parameter venues: An array of `Venue` objects to update.
    /// - Returns: An array of `Venue` objects with updated favorite states.
    private func updateFavouriteState(for venues: [Venue]) -> [Venue] {
        return venues.map { venue -> Venue in
            var updatedVenue = venue
            updatedVenue.isFavourite = localStorageService.isFavourite(id: venue.id)
            return updatedVenue
        }
    }
}

