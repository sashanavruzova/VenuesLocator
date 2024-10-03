//
//  Venue.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import Foundation

struct VenueResponse: Codable {
    let sections: [Section]
}

struct Section: Codable {
    let items: [Item]
}

struct Item: Codable {
    var venue: Venue?

    enum CodingKeys: String, CodingKey {
        case venue
        case image
    }

    enum ImageKeys: String, CodingKey {
        case url
    }

    init(venue: Venue?) {
        self.venue = venue
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.venue = try container.decodeIfPresent(Venue.self, forKey: .venue)

        // Decode the image URL from the nested `image` container
        if let imageUrl = try? container.nestedContainer(keyedBy: ImageKeys.self, forKey: .image).decode(String.self, forKey: .url) {
            self.venue?.imageUrl = imageUrl
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(venue, forKey: .venue)

        // Encode the image URL if available
        if let imageUrl = venue?.imageUrl {
            var imageContainer = container.nestedContainer(keyedBy: ImageKeys.self, forKey: .image)
            try imageContainer.encode(imageUrl, forKey: .url)
        }
    }
}

struct Venue: Codable, Equatable {
    let id: String
    let name: String
    let shortDescription: String?
    var imageUrl: String?
    var isFavourite: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortDescription = "short_description"
    }
    
    init(id: String, name: String, shortDescription: String? = nil, imageUrl: String? = nil, isFavourite: Bool = false) {
         self.id = id
         self.name = name
         self.shortDescription = shortDescription
         self.imageUrl = imageUrl
         self.isFavourite = isFavourite
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(shortDescription, forKey: .shortDescription)
    }
}


