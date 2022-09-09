import Foundation

struct ForecastTodayModel: Codable, Hashable {
    static func == (lhs: ForecastTodayModel, rhs: ForecastTodayModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    let main: Main
    let wind: Wind
    let sys: Sys
    let name: String
    let weather: [Weather]
    let dt: Int
    let visibility: Int
    let clouds: Clouds
    let coord: CityCoord
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct CityCoord: Encodable, Decodable, Hashable {
        var lat, lon: Double

    }
    
    struct Main: Codable {
        let temp, tempMin, tempMax: Double
        let pressure, humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case pressure, humidity
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    struct Sys: Codable {
        let country: String
        let sunrise, sunset: Int
    }
    
    struct Weather: Codable {
        let main, weatherDescription /*icon*/: String
        let id: Int
        
        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
            //          case icon
        }
    }
    
    struct Wind: Codable {
        let speed: Double
    }

}



