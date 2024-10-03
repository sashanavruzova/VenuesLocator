//
//  MockFetchVenuesUseCase.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 03.10.2024.
//

import XCTest
@testable import VenuesLocator

final class MockFetchVenuesUseCase: FetchVenuesUseCaseProtocol {
    var result: Result<[Venue], Error>?

    func execute(latitude: Double, longitude: Double, completion: @escaping (Result<[Venue], Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}


