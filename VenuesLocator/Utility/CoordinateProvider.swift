//
//  CoordinateProvider.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import Foundation

/// Provides a set of predefined coordinates for venue locations.
struct CoordinateProvider {
    static let predefinedCoordinates: [Coordinate] = [
        Coordinate(latitude: 60.170187, longitude: 24.930599),
        Coordinate(latitude: 60.169418, longitude: 24.931618),
        Coordinate(latitude: 60.169818, longitude: 24.932906),
        Coordinate(latitude: 60.170005, longitude: 24.935105),
        Coordinate(latitude: 60.169108, longitude: 24.936210),
        Coordinate(latitude: 60.168355, longitude: 24.934869),
        Coordinate(latitude: 60.167560, longitude: 24.932562),
        Coordinate(latitude: 60.168254, longitude: 24.931532),
        Coordinate(latitude: 60.169012, longitude: 24.930341),
        Coordinate(latitude: 60.170085, longitude: 24.929569)
    ]
}

/// Represents a geographical coordinate with latitude and longitude.
struct Coordinate: Equatable {
    let latitude: Double
    let longitude: Double
}
