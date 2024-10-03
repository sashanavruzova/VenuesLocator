//
//  UIView+Animation.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import UIKit

/// Extension for `UIImageView` to load images from a URL.
extension UIImageView {
    /// Loads an image from the provided URL.
    /// - Parameter url: The URL to load the image from.
    func setImage(from url: URL) {
        ImageLoader.shared.loadImage(from: url) { [weak self] image in
            self?.image = image
        }
    }
}

/// Extension for `UIView` to add a bounce animation effect.
extension UIView {
    /// Adds a bounce animation to the view.
    /// - Parameters:
    ///   - delay: The delay before starting the animation (defaults to 0).
    ///   - completion: Optional completion handler.
    func withBounceAnimation(delay: Double = 0, completion: (() -> Void)? = nil) {
        self.transform = CGAffineTransform(translationX: 0, y: 50)
        self.alpha = 0

        UIView.animate(withDuration: 0.6,
                       delay: delay,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: {
            self.transform = .identity
            self.alpha = 1
        }, completion: nil)
    }
}
