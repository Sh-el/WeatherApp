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
}

//MARK: - Main
extension ForecastTodayModel {
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
}

//MARK: - Wind
extension ForecastTodayModel {
    struct Wind: Codable {
        let speed: Double
    }
}

//MARK: - Sys
extension ForecastTodayModel {
    struct Sys: Codable {
        let country: String
        let sunrise, sunset: Int
    }
}

//MARK: - Weather
extension ForecastTodayModel {
    struct Weather: Codable {
        let main, weatherDescription /*icon*/: String
        let id: Int
        
        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
        }
    }
}

//MARK: - Clouds
extension ForecastTodayModel {
    struct Clouds: Codable {
        let all: Int
    }
}

//MARK: - CityCoord
extension ForecastTodayModel {
    struct CityCoord: Encodable, Decodable, Hashable {
        var lat, lon: Double
    }
}





