//
//  MockVenuesViewModelDelegate.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 03.10.2024.
//

import XCTest
@testable import VenuesLocator

final class MockVenuesViewModelDelegate: VenuesViewModelDelagate {
    var didUpdateVenuesClosure: (([Venue], Bool) -> Void)?
    var didFailWithErrorClosure: ((Error) -> Void)?

    var didUpdateVenuesCalled = false
    var didFailWithErrorCalled = false
    var updatedVenues: [Venue]?
    var animationFlag: Bool = false

    func didUpdateVenues(_ venues: [Venue], withAnimation: Bool) {
        didUpdateVenuesCalled = true
        updatedVenues = venues
        animationFlag = withAnimation
        didUpdateVenuesClosure?(venues, withAnimation)
    }

    func didfailWithError(_ error: Error) {
        didFailWithErrorCalled = true
        didFailWithErrorClosure?(error)
    }
    
    func reset() {
        didUpdateVenuesCalled = false
        didFailWithErrorCalled = false
        updatedVenues = nil
        animationFlag = false
    }

}

