//
//  NetworkService.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import Foundation

/// `NetworkService` handles fetching venue data, managing favorite states, and communicates changes to the `VenuesViewController`.
/// It provides a generic method for requesting and decoding data, designed for reuse across the application.
class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    /// Makes a network request to a given URL and decodes the response into a specified Decodable type.
    /// - Parameters:
    ///   - url: The URL to make the request to.
    ///   - completion: A closure that handles the result of the request, either success with the decoded response or failure with an error.
    /// - Note: This method handles decoding any type that conforms to `Decodable`.
    func request<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
