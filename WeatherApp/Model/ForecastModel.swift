import Foundation
import Combine

struct ForecastModel {
    struct Forecast: Equatable {
        static func ==(lhs: ForecastModel.Forecast, rhs: ForecastModel.Forecast) -> Bool {
            return lhs.id == rhs.id
        }
        
        let id = UUID()
        let forecastToday : ForecastTodayModel
        let forecastForFiveDaysThreeHours: ForecastForFiveDaysThreeHoursModel
        let forecastForFiveDays: ForecastForFiveDaysModel
        let airPollutionModel: AirPollutionModel
    }
}

extension ForecastModel {
    static func nameOfDayOfWeek(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Int, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter{$0.dt > Int(tommorow)}
            .map{Int($0.dt)}
            .collect(8)
            .map{$0.min() ?? 0}
            .eraseToAnyPublisher()
    }
    
    static func minDaytimeTemp(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Int, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter{$0.dt > Int(tommorow)}
            .map{Int($0.main.temp)}
            .collect(8)
            .map{$0.min() ?? 0}
            .eraseToAnyPublisher()
    }
    
    static func maxDaytimeTemp(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Int, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter{$0.dt > Int(tommorow)}
            .map{Int($0.main.temp)}
            .collect(8)
            .map{$0.max() ?? 0}
            .eraseToAnyPublisher()
    }
    
    static func maxDaytimeRain(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Double, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter{$0.dt > Int(tommorow)}
            .map{$0.pop}
            .collect(8)
            .map{$0.max() ?? 0.0}
            .eraseToAnyPublisher()
    }
    
    static func dataForecast(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<ForecastForFiveDaysModel, Never> {
        Publishers.Zip4(
            nameOfDayOfWeek(forecast),
            minDaytimeTemp(forecast),
            maxDaytimeTemp(forecast),
            maxDaytimeRain(forecast)
        )
        .map{ForecastForFiveDaysModel.List(dt: $0.0,
                                           minTemp: $0.1,
                                           maxTemp: $0.2,
                                           maxRain: $0.3)}
        .collect()
        .map{ForecastForFiveDaysModel(list: $0)}
        .eraseToAnyPublisher()
    }
    
    static func createFivedayWeatherForecast(_ data: Data) -> AnyPublisher<ForecastForFiveDaysModel, Error> {
        API.decode(data)
            .flatMap(dataForecast)
            .tryMap{$0}
            .eraseToAnyPublisher()
    }
}

extension ForecastModel {
    enum EndPoint {
        static private let apiKey = "06d1fe9aeaf87501637b6638e8a5dbbf"
        
        case forecastToday
        case forecastForFiveDaysThreeHours
        case airPollution
        case geocoding
       
        var url: String {
            switch self {
            case .forecastToday:
                return "https://api.openweathermap.org/data/2.5/weather?&limit=5&appid="
                + EndPoint.apiKey + "&units=metric"
            case .forecastForFiveDaysThreeHours:
                return "https://api.openweathermap.org/data/2.5/forecast?&limit=5&appid="
                + EndPoint.apiKey + "&units=metric"
            case .airPollution:
                return "http://api.openweathermap.org/data/2.5/air_pollution?&limit=5&appid="
                + EndPoint.apiKey + "&units=metric"
            case .geocoding:
                return "http://api.openweathermap.org/geo/1.0/direct?&units=metric&limit=5&appid="
                + EndPoint.apiKey + "&q="
            }
        }
    }
    
    static func fetchWeatherForecast(_ coord: ForecastTodayModel.CityCoord) -> AnyPublisher<Forecast, Error> {
        Publishers.Zip3(
            API.fetch(url: EndPoint.forecastToday.url + "&lat=\(coord.lat)&lon=\(coord.lon)"),
            API.fetch(url: EndPoint.forecastForFiveDaysThreeHours.url + "&lat=\(coord.lat)&lon=\(coord.lon)"),
            API.fetch(url: EndPoint.airPollution.url + "&lat=\(coord.lat)&lon=\(coord.lon)")
        )
        .flatMap{
            Publishers.Zip3(
                API.fetchData($0.0),
                API.fetchData($0.1),
                API.fetchData($0.2)
            )
        }
        .flatMap{
            Publishers.Zip4(
                API.decode($0.0),
                API.decode($0.1),
                ForecastModel.createFivedayWeatherForecast($0.1),
                API.decode($0.2)
            )
        }
        .map{
            Forecast(
                forecastToday: $0.0,
                forecastForFiveDaysThreeHours: $0.1,
                forecastForFiveDays: $0.2,
                airPollutionModel: $0.3
            )
        }
        .eraseToAnyPublisher()
    }
}

extension ForecastModel {
    static func fetchWeatherForecasts(_ coords: [ForecastTodayModel.CityCoord]) -> AnyPublisher<[Forecast], Error> {
        var indexes: [ForecastTodayModel.CityCoord: Int] = [:]
        for (index, entry) in coords.enumerated() {
            indexes[entry.self] = index
        }
        
        return coords
            .publisher
            .flatMap(fetchWeatherForecast)
            .collect()
            .sort{a, b in
                indexes[a.forecastToday.coord]! < indexes[b.forecastToday.coord]!
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output: Sequence {
    typealias Sorter = (Output.Element, Output.Element) -> Bool
    
    func sort(by sorter: @escaping Sorter) -> Publishers.Map<Self, [Output.Element]> {
        map {sequence in
            sequence.sorted(by: sorter)
        }
    }
}


