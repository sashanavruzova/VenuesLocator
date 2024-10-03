//
//  FetchVenuesUseCaseTests.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 02.10.2024.
//

import XCTest
@testable import VenuesLocator

final class FetchVenuesUseCaseTests: XCTestCase {
    // MARK: Properties
    var fetchVenuesUseCase: FetchVenuesUseCaseProtocol!
    var mockVenueAPI: MockVenueAPI!
    var mockLocalStorageService: MockLocalStorageService!
    
    let testLatitude: Double = 60.17
    let testLongitude: Double = 24.93

    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        mockVenueAPI = MockVenueAPI()
        mockLocalStorageService = MockLocalStorageService()
        fetchVenuesUseCase = FetchVenuesUseCase(venueAPI: mockVenueAPI, localStorageService: mockLocalStorageService)
    }

    override func tearDown() {
        fetchVenuesUseCase = nil
        mockVenueAPI = nil
        mockLocalStorageService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testExecute_whenApiReturnsSuccess_shouldReturnFirst15Venues() {
        // Arrange
        let mockVenues = createMockVenues(count: 20)
        let venueResponse = makeVenueResponse(with: mockVenues)
        
        mockVenueAPI.venuesResponse = venueResponse

        let expectation = self.expectation(description: "Fetch venues should succeed and return first 15 venues")

        // Act
        fetchVenuesUseCase.execute(latitude: testLatitude, longitude: testLongitude) { result in
            // Assert
            self.expectSuccess(result, expectedVenueCount: 15, expectation: expectation)
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testExecute_whenApiReturnsSuccess_shouldUpdateFavoriteStatus() {
        // Arrange
        let mockVenue = Venue(id: "1", name: "Test Venue 1", shortDescription: "A test venue", imageUrl: nil, isFavourite: false)
        let venueResponse = makeVenueResponse(with: [mockVenue])
        
        mockVenueAPI.venuesResponse = venueResponse
        mockLocalStorageService.favouriteIds = ["1"]

        let expectation = self.expectation(description: "Fetch venues should succeed and update favorite status")

        // Act
        fetchVenuesUseCase.execute(latitude: testLatitude, longitude: testLongitude) { result in
            // Assert
            self.expectSuccess(result, expectedVenueCount: 1, expectation: expectation)
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testExecute_whenApiReturnsFailure_shouldReturnError() {
        // Arrange
        mockVenueAPI.shouldReturnError = true

        let expectation = self.expectation(description: "Fetch venues should fail with error")

        // Act
        fetchVenuesUseCase.execute(latitude: testLatitude, longitude: testLongitude) { result in
            // Assert
            self.expectFailure(result, expectedErrorMessage: "Mock Error", expectation: expectation)
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testExecute_whenApiReturnsEmptySections_shouldReturnNoVenues() {
        // Arrange
        let venueResponse = VenueResponse(sections: [])
        mockVenueAPI.venuesResponse = venueResponse

        let expectation = self.expectation(description: "Fetch venues should return no venues")

        // Act
        fetchVenuesUseCase.execute(latitude: testLatitude, longitude: testLongitude) { result in
            // Assert
            self.expectSuccess(result, expectedVenueCount: 0, expectation: expectation)
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // MARK: - Helper Methods
    private func createMockVenues(count: Int) -> [Venue] {
        return (1...count).map { index in
            Venue(id: "\(index)", name: "Test Venue \(index)", shortDescription: "A test venue \(index)", imageUrl: nil, isFavourite: false)
        }
    }
    
    private func makeVenueResponse(with venues: [Venue]) -> VenueResponse {
        let items = venues.map { Item(venue: $0) }
        let section = Section(items: items)
        return VenueResponse(sections: [section])
    }
    
    private func expectSuccess(_ result: Result<[Venue], Error>, expectedVenueCount: Int, expectation: XCTestExpectation, additionalAssertions: (([Venue]) -> Void)? = nil) {
        switch result {
        case .success(let venues):
            XCTAssertEqual(venues.count, expectedVenueCount, "Should return \(expectedVenueCount) venues")
            additionalAssertions?(venues)
        case .failure(let error):
            XCTFail("Expected success, but got failure with error: \(error)")
        }
        expectation.fulfill()
    }

    private func expectFailure(_ result: Result<[Venue], Error>, expectedErrorMessage: String, expectation: XCTestExpectation) {
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual((error as NSError).localizedDescription, expectedErrorMessage, "Error message should match the mocked error")
        }
        expectation.fulfill()
    }
}

