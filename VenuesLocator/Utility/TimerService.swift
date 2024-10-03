//
//  TimerService.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import Foundation

/// Service to manage a repeating timer.
class TimerService {
    private var timer: Timer?
    
    func start(interval: TimeInterval, repeats: Bool, action: @escaping () -> Void) {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats) { _ in
            action()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
