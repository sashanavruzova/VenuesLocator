//
//  MockVenueAPI.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 02.10.2024.
//

import XCTest
@testable import VenuesLocator

final class MockVenueAPI: VenueAPI {
    var shouldReturnError = false
    var venuesResponse: VenueResponse?
    
    override func fetchVenues(latitude: Double, longitude: Double, completion: @escaping (Result<VenueResponse, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])))
        } else if let venuesResponse = venuesResponse {
            completion(.success(venuesResponse))
        }
    }
}
