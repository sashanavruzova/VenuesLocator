//
//  VenuesViewModel.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import Foundation

protocol VenuesViewModelDelagate: AnyObject {
    func didUpdateVenues(_ venues: [Venue], withAnimation: Bool)
    func didfailWithError(_ error: Error)
}

/// `VenuesViewModel` handles fetching venue data, managing favorite states, and communicates changes to the `VenuesViewController`.
/// It uses `FetchVenuesUseCase` for fetching data and `UpdateFavouriteUseCase` for handling favorite logic.
class VenuesViewModel {
    private let fetchVenuesUseCase: FetchVenuesUseCaseProtocol
    private let updateFavouriteUseCase: UpdateFavouriteUseCaseProtocol
    private var timerService: TimerService
    private var locations: [Coordinate]
    private var currentLocationIndex = 0
    weak var delegate: VenuesViewModelDelagate?

    private var venues: [Venue] = []
    
    init(fetchVenuesUseCase: FetchVenuesUseCaseProtocol, updateFavouriteUseCase: UpdateFavouriteUseCaseProtocol, timerService: TimerService = TimerService(), locations: [Coordinate] = CoordinateProvider.predefinedCoordinates) {
        self.fetchVenuesUseCase = fetchVenuesUseCase
        self.updateFavouriteUseCase = updateFavouriteUseCase
        self.timerService = timerService
        self.locations = locations
    }
    
    func startFetchingVenues() {
        timerService.start(interval: 10, repeats: true) { [weak self] in
            self?.fetchNextVenue()
        }
    }
    
    func stopFetchingTimer() {
        timerService.stop()
    }
    
    /// Toggles the favorite status of a specific venue.
    /// - Parameter venue: The venue to toggle as favorite.
    /// Updates both the local storage and the UI delegate.
    func toggleFavourite(for venue: Venue) {
        updateFavouriteUseCase.execute(venue: venue)
        
        guard let index = venues.firstIndex(where: { $0.id == venue.id }) else { return }
        venues[index].isFavourite.toggle()
        delegate?.didUpdateVenues(venues, withAnimation: false)
    }
    
    /// Fetches the next venue based on the current location index.
    /// The method uses a cycling list of predefined coordinates to simulate location changes.
    private func fetchNextVenue() {
        let location = getNextLocation()
        fetchVenues(for: location)
    }
    
    /// Retrieves the next coordinate to simulate location change, looping back to the beginning if necessary.
    private func getNextLocation() -> Coordinate {
        let location = locations[currentLocationIndex]
        currentLocationIndex += 1

        if currentLocationIndex >= locations.count {
            currentLocationIndex = 0
        }

        return location
    }
    
    /// Fetches venues for a given location using the `FetchVenuesUseCase`.
    private func fetchVenues(for location: Coordinate) {
        fetchVenuesUseCase.execute(latitude: location.latitude, longitude: location.longitude) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleFetchResult(result)
            }
        }
    }
    
    /// Handles the result of fetching venues, either updating the list of venues or notifying the delegate of an error.
    private func handleFetchResult(_ result: Result<[Venue], Error>) {
        switch result {
        case .success(let fetchedVenues):
            self.venues = fetchedVenues
            delegate?.didUpdateVenues(fetchedVenues, withAnimation: true)
        case .failure(let error):
            delegate?.didfailWithError(error)
        }
    }
}
