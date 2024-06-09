//
//  Note.swift
//  NoteApp
//
//  Created by דוד נוי on 07/06/2024.
//

import Foundation
import CoreLocation

struct Note: Codable {
    var id: UUID
    var title: String
    var content: String
    var location: CLLocationCoordinate2D?
    var imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case latitude
        case longitude
        case imageUrl
    }

    init(title: String, content: String, location: CLLocationCoordinate2D?, imageUrl: String?) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.location = location
        self.imageUrl = imageUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)

        if let latitude = try container.decodeIfPresent(Double.self, forKey: .latitude),
           let longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) {
            self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.location = nil
        }

        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)

        if let location = location {
            try container.encode(location.latitude, forKey: .latitude)
            try container.encode(location.longitude, forKey: .longitude)
        }

        try container.encode(imageUrl, forKey: .imageUrl)
    }
}
