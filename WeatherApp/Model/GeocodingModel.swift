import Foundation
import Combine

struct GeocodingModel {
    
    struct Geocoding: Codable {
        let id = UUID()
        let name: String
        let lat, lon: Double
        let country: String
        let state: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case lat, lon, country, state
        }
    }
}

