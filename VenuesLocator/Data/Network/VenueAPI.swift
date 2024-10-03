//
//  VenueAPI.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import Foundation

class VenueAPI {
    
    private let baseURL = "https://restaurant-api.wolt.com/v1/pages/restaurants"
    
    func fetchVenues(latitude: Double,
                     longitude: Double,
                     completion: @escaping (Result<VenueResponse, Error>) -> Void) {
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)")
        ]
        
        guard let url = urlComponents.url else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL"])
            completion(.failure(error))
            return
        }
        
        NetworkService.shared.request(url: url, completion: completion)
    }
}

