//
//  MockUpdateFavouriteUseCase.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 03.10.2024.
//

import XCTest
@testable import VenuesLocator

final class MockUpdateFavouriteUseCase: UpdateFavouriteUseCaseProtocol {
    var executeClosure: ((Venue) -> Void)?
    
    func execute(venue: Venue) {
        executeClosure?(venue)
    }
}


