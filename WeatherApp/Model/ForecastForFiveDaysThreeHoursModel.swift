import Foundation

struct ForecastForFiveDaysThreeHoursModel: Codable {
    let list: [List]
    let city: City
}

//MARK: - List
extension ForecastForFiveDaysThreeHoursModel {
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
}

//MARK: - Main
extension ForecastForFiveDaysThreeHoursModel {
    struct Main: Codable {
        let temp, tempMin, tempMax: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
}

//MARK: - Weather
extension ForecastForFiveDaysThreeHoursModel {
    struct Weather: Codable {
        let main, weatherDescription, icon: String
        let id: Int
        
        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
            case icon
        }
    }
}

//MARK: - Clouds
extension ForecastForFiveDaysThreeHoursModel {
    struct Clouds: Codable {
        let all: Int
    }
}

//MARK: - Wind
extension ForecastForFiveDaysThreeHoursModel {
    struct Wind: Codable {
        let speed: Double
    }
}

//MARK: - Sys
extension ForecastForFiveDaysThreeHoursModel {
    struct Sys: Codable {
        let pod: String
    }
}

//MARK: - City
extension ForecastForFiveDaysThreeHoursModel {
    struct City: Codable {
        let id: Int
        let name: String
        //      let country: String
    }
}



