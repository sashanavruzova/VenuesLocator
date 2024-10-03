//
//  LocalStorageServiceTest.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 03.10.2024.
//

import XCTest
@testable import VenuesLocator

final class LocalStorageServiceTests: XCTestCase {
    // MARK: Properties
    var localStorageService: LocalStorageService!
    var mockUserDefaults: MockUserDefaults!

    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        localStorageService = LocalStorageService(userDefaults: mockUserDefaults)
    }

    override func tearDown() {
        localStorageService = nil
        mockUserDefaults = nil
        super.tearDown()
    }

    // MARK: - Tests
    func testGetFavouriteVenueIds_whenNoIdsStored_shouldReturnEmptyArray() {
        // Act
        let favouriteIds = localStorageService.getFavouriteVenueIds()

        // Assert
        XCTAssertTrue(favouriteIds.isEmpty, "Expected empty array when no IDs are stored")
    }

    func testGetFavouriteVenueIds_whenIdsAreStored_shouldReturnStoredIds() {
        // Arrange
        let expectedIds = ["1", "2", "3"]
        mockUserDefaults.set(expectedIds, forKey: "favouriteVenues")

        // Act
        let favouriteIds = localStorageService.getFavouriteVenueIds()

        // Assert
        XCTAssertEqual(favouriteIds, expectedIds, "Expected stored IDs to match the ones returned")
    }

    func testSetFavouriteVenueIds_shouldStoreIdsInUserDefaults() {
        // Arrange
        let idsToStore = ["1", "2", "3"]

        // Act
        localStorageService.setFavouriteVenueIds(idsToStore)

        // Assert
        let storedIds = mockUserDefaults.array(forKey: "favouriteVenues") as? [String]
        XCTAssertEqual(storedIds, idsToStore, "Expected stored IDs to match the ones that were set")
    }

    func testIsFavourite_whenIdIsStored_shouldReturnTrue() {
        // Arrange
        let favouriteId = "1"
        mockUserDefaults.set([favouriteId], forKey: "favouriteVenues")

        // Act
        let isFavourite = localStorageService.isFavourite(id: favouriteId)

        // Assert
        XCTAssertTrue(isFavourite, "Expected isFavourite to return true for stored ID")
    }

    func testIsFavourite_whenIdIsNotStored_shouldReturnFalse() {
        // Arrange
        let favouriteId = "1"
        mockUserDefaults.set(["2", "3"], forKey: "favouriteVenues")

        // Act
        let isFavourite = localStorageService.isFavourite(id: favouriteId)

        // Assert
        XCTAssertFalse(isFavourite, "Expected isFavourite to return false for ID that is not stored")
    }
}

