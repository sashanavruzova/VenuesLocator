//
//  UpdateFavouriteUseCaseTests.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 03.10.2024.
//

import XCTest
@testable import VenuesLocator

final class UpdateFavouriteUseCaseTests: XCTestCase {
    // MARK: Properties
    var updateFavouriteUseCase: UpdateFavouriteUseCase!
    var mockLocalStorageService: MockLocalStorageService!
    
    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        mockLocalStorageService = MockLocalStorageService()
        updateFavouriteUseCase = UpdateFavouriteUseCase(localStorageService: mockLocalStorageService)
    }

    override func tearDown() {
        updateFavouriteUseCase = nil
        mockLocalStorageService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testExecute_whenVenueIsNotFavourite_shouldAddToFavourites() {
        // Arrange
        let venue = makeVenue()
        mockLocalStorageService.favouriteIds = []

        // Act
        updateFavouriteUseCase.execute(venue: venue)

        // Assert
        XCTAssertTrue(mockLocalStorageService.favouriteIds.contains(venue.id), "Venue ID should be added to favourites")
    }

    func testExecute_whenVenueIsAlreadyFavourite_shouldRemoveFromFavourites() {
        // Arrange
        let venue = makeVenue(id: "1", isFavourite: true)
        mockLocalStorageService.favouriteIds = ["1"]

        // Act
        updateFavouriteUseCase.execute(venue: venue)

        // Assert
        XCTAssertFalse(mockLocalStorageService.favouriteIds.contains(venue.id), "Venue ID should be removed from favourites")
    }

    func testExecute_whenVenueIsNotFavourite_shouldDoNothingIfRemoving() {
        // Arrange
        let venue = makeVenue()
        mockLocalStorageService.favouriteIds = []

        // Act
        updateFavouriteUseCase.execute(venue: venue)

        // Assert
        XCTAssertEqual(mockLocalStorageService.favouriteIds.count, 1, "Venue ID should be added to favourites if it is not present")
    }
    
    // MARK: - Helper Methods
    private func makeVenue(id: String = "1", name: String = "Test Venue", isFavourite: Bool = false) -> Venue {
        return Venue(id: id, name: name, shortDescription: "A test venue", imageUrl: nil, isFavourite: isFavourite)
    }
}
