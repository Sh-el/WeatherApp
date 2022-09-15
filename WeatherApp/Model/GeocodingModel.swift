import Foundation
import Combine

struct GeocodingModel {
    
    struct Geocoding: Codable {
        let id = UUID()
        let name: String
//      let localNames: LocalNames
        let lat, lon: Double
        let country: String
        let state: String?
        
        enum CodingKeys: String, CodingKey {
            case name
//          case localNames = "local_names"
            case lat, lon, country, state
        }
        
//    struct LocalNames: Codable {
//        let en: String
//        let ru: String?
        
//        enum CodingKeys: String, CodingKey {
//            case  en, ru
//            case featureName = "feature_name"
        
//        }
//    }
     
    }
    
}

