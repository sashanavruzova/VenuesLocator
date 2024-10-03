//
//  MockUserDefaults.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 03.10.2024.
//

import XCTest
@testable import VenuesLocator

final class MockUserDefaults: UserDefaults {
    private var store = [String: Any]()
    
    override func set(_ value: Any?, forKey defaultName: String) {
        store[defaultName] = value
    }
    
    override func array(forKey defaultName: String) -> [Any]? {
        return store[defaultName] as? [Any]
    }
}
