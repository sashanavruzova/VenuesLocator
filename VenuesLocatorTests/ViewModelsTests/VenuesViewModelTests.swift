//
//  VenuesViewModelTests.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 03.10.2024.
//

import XCTest
@testable import VenuesLocator

class VenuesViewModelTests: XCTestCase {
    // MARK: Properties
    var viewModel: VenuesViewModel!
    var mockFetchVenuesUseCase: MockFetchVenuesUseCase!
    var mockUpdateFavouriteUseCase: MockUpdateFavouriteUseCase!
    var mockTimerService: MockTimerService!
    var mockDelegate: MockVenuesViewModelDelegate!
    
    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        mockFetchVenuesUseCase = MockFetchVenuesUseCase()
        mockUpdateFavouriteUseCase = MockUpdateFavouriteUseCase()
        mockTimerService = MockTimerService()
        mockDelegate = MockVenuesViewModelDelegate()
        
        // Create the view model using the mocks
        viewModel = VenuesViewModel(
            fetchVenuesUseCase: mockFetchVenuesUseCase,
            updateFavouriteUseCase: mockUpdateFavouriteUseCase,
            timerService: mockTimerService,
            locations: CoordinateProvider.predefinedCoordinates
        )
        viewModel.delegate = mockDelegate
    }

    override func tearDown() {
        viewModel = nil
        mockFetchVenuesUseCase = nil
        mockUpdateFavouriteUseCase = nil
        mockTimerService = nil
        mockDelegate = nil
        super.tearDown()
    }

    // MARK: - Tests
    func testStartFetchingVenues_whenCalled_shouldStartTimer() {
        // Act
        viewModel.startFetchingVenues()
        
        // Assert
        XCTAssertTrue(mockTimerService.startInvoked, "Timer should be started")
        XCTAssertEqual(mockTimerService.interval, 10, "Timer interval should be 10 seconds")
    }

    func testStopFetchingTimer_whenCalled_shouldStopTimer() {
        // Arrange
        viewModel.startFetchingVenues()
        
        // Act
        viewModel.stopFetchingTimer()
        
        // Assert
        XCTAssertTrue(mockTimerService.stopInvoked, "Timer should be stopped")
    }
    
    func testToggleFavourite_whenVenueIsNotFound_shouldNotCallDelegate() {
        // Arrange
        let mockVenue = createMockVenue(id: "1", isFavourite: false)
        viewModel.toggleFavourite(for: mockVenue)

        // Assert
        XCTAssertFalse(mockDelegate.didUpdateVenuesCalled, "Delegate's didUpdateVenues should not be called if the venue is not found")
    }
    
    func testToggleFavourite_whenVenueIsNotFavourite_shouldMarkAsFavourite() {
        // Arrange
        let mockVenue = createMockVenue(id: "1", isFavourite: false)
        setupViewModelWithVenue(mockVenue)

        let toggleExpectation = self.expectation(description: "Favourite state should be toggled to true and delegate should be called without animation")

        mockDelegate.didUpdateVenuesClosure = { venues, withAnimation in
            XCTAssertEqual(venues.count, 1, "Should return 1 venue")
            XCTAssertTrue(venues.first?.isFavourite == true, "Venue should be marked as favourite")
            XCTAssertFalse(withAnimation, "Animation flag should be false for toggle action")
            toggleExpectation.fulfill()
        }

        // Act
        viewModel.toggleFavourite(for: mockVenue)

        // Assert
        wait(for: [toggleExpectation], timeout: 1.0)
    }
    
    func testToggleFavourite_whenVenueIsFavourite_shouldUnmarkAsFavourite() {
        // Arrange
        let mockVenue = createMockVenue(id: "1", isFavourite: true)
        setupViewModelWithVenue(mockVenue)

        let toggleExpectation = self.expectation(description: "Favourite state should be toggled to false and delegate should be called without animation")

        mockDelegate.didUpdateVenuesClosure = { venues, withAnimation in
            XCTAssertEqual(venues.count, 1, "Should return 1 venue")
            XCTAssertFalse(venues.first?.isFavourite == true, "Venue should be unmarked as favourite")
            XCTAssertFalse(withAnimation, "Animation flag should be false for toggle action")
            toggleExpectation.fulfill()
        }

        // Act
        viewModel.toggleFavourite(for: mockVenue)

        // Assert
        wait(for: [toggleExpectation], timeout: 1.0)
    }
    
    func testFetchNextVenue_whenApiReturnsFailure_shouldCallDelegateWithError() {
        // Arrange
        let mockError = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])
        mockFetchVenuesUseCase.result = .failure(mockError)

        let expectation = self.expectation(description: "Delegate should be called with an error")

        // Mock the delegate closure to capture the error
        mockDelegate.didFailWithErrorClosure = { error in
            XCTAssertEqual((error as NSError).localizedDescription, "Mock Error", "Error message should match the mocked error")
            expectation.fulfill()
        }

        // Act
        viewModel.startFetchingVenues()

        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // MARK: - Helper Methods
    private func createMockVenue(id: String, isFavourite: Bool) -> Venue {
        return Venue(id: id, name: "Test Venue \(id)", shortDescription: "A test venue", imageUrl: nil, isFavourite: isFavourite)
    }
    
    private func setupViewModelWithVenue(_ venue: Venue) {
        mockFetchVenuesUseCase.result = .success([venue])
        viewModel.startFetchingVenues()
        
        let initialExpectation = self.expectation(description: "Initial fetch venues should succeed")
        mockDelegate.didUpdateVenuesClosure = { _, _ in
            initialExpectation.fulfill()
        }
        wait(for: [initialExpectation], timeout: 1.0)

        // Reset the delegate for the next action
        mockDelegate.reset()
    }
}
