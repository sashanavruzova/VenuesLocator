//
//  MockTimerService.swift
//  VenuesLocatorTests
//
//  Created by Sasha Navruzova on 03.10.2024.
//

import XCTest
@testable import VenuesLocator

final class MockTimerService: TimerService {
    var startInvoked = false
    var stopInvoked = false
    var interval: TimeInterval?
    
    override func start(interval: TimeInterval, repeats: Bool, action handler: @escaping () -> Void) {
        startInvoked = true
        self.interval = interval
        handler() // Immediately call handler to simulate the timer
    }
    
    override func stop() {
        stopInvoked = true
    }
}
