//
//  ImageLoader.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import UIKit

/// Singleton class responsible for loading and caching images.
class ImageLoader {
    static let shared = ImageLoader()
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    /// Loads an image from the given URL, either from cache or via a network request.
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString
        
        if let cachedImage = imageCache.object(forKey: cacheKey as NSString) {
            completion(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.imageCache.setObject(image, forKey: cacheKey as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
