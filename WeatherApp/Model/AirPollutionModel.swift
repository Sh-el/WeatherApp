import Foundation

struct AirPollutionModel: Codable {
    let list: [List]
    
    struct List: Codable {
        let main: Main
        let components: [String: Double]
        let dt: Int
    }
    
    struct Main: Codable {
        let aqi: Int
    }
    
}




