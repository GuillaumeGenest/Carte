//
//  Location.swift
//  Carte
//
//  Created by Guillaume Genest on 15/05/2023.
//

import Foundation
/*
struct Location: Identifiable {
    var id = UUID()
    var name: String
    var cityName: String
    var latitude: Double
    var longitude: Double
    var description: String
    var category: CategoryPlace
    var imageURL: String
}
*/

/*
class Location: Identifiable, ObservableObject, Equatable , Codable{
    @Published var id = UUID()
    @Published var name: String
    @Published var cityName: String
    @Published var latitude: Double
    @Published var longitude: Double
    @Published var description: String
    @Published var category: CategoryPlace
    @Published var imageURL: String
    
    
    // Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    
    init(name: String, cityName: String, latitude: Double, longitude: Double, description: String, category: CategoryPlace, imageURL: String){
        self.name = name
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.category = category
        self.imageURL = imageURL
    }
    
    enum CodingKeys: CodingKey {
            case id
            case name
            case cityName
            case latitude
            case longitude
            case description
            case category
            case imageURL
        }
    
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(UUID.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.cityName = try container.decode(String.self, forKey: .cityName)
            self.latitude = try container.decode(Double.self, forKey: .latitude)
            self.longitude = try container.decode(Double.self, forKey: .longitude)
            self.description = try container.decode(String.self, forKey: .description)
            self.category = try container.decode(CategoryPlace.self, forKey: .category)
            self.imageURL = try container.decode(String.self, forKey: .imageURL)
    }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(cityName, forKey: .cityName)
            try container.encode(latitude, forKey: .latitude)
            try container.encode(longitude, forKey: .longitude)
            try container.encode(description, forKey: .description)
            try container.encode(category, forKey: .category)
            try container.encode(imageURL, forKey: .imageURL)
        }
}
*/


