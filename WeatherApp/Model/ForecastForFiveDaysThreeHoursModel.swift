import Foundation

struct ForecastForFiveDaysThreeHoursModel: Codable {
    
    let list: [List]
    let city: City
    
    struct City: Codable {
        let id: Int
        let name: String
//      let country: String
    }
    
    struct List: Codable {
        
        let id = UUID()
        let dt: Int
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let dtTxt: String
        let sys: Sys
        let pop: Double
        
        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, sys, pop
            case dtTxt = "dt_txt"
        }
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Main: Codable {
        let temp, tempMin, tempMax: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    struct Sys: Codable {
        let pod: String
    }
    
    struct Weather: Codable {
        let main, weatherDescription, icon: String
        let id: Int
        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
            case icon
        }
    }
    
    struct Wind: Codable {
        let speed: Double
    }
    
}

