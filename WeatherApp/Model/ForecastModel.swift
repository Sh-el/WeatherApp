import Foundation
import Combine

struct ForecastModel {
    
    struct Forecast: Equatable {
        static func == (lhs: ForecastModel.Forecast, rhs: ForecastModel.Forecast) -> Bool {
            return lhs.id == rhs.id
        }
        
        var id = UUID()
        let forecastToday : ForecastTodayModel
        let forecastForFiveDaysThreeHours: ForecastForFiveDaysThreeHoursModel
        let forecastForFiveDays: ForecastForFiveDaysModel
        let airPollutionModel: AirPollutionModel

    }
}

private extension ForecastModel {
    
    static func nameOfDayOfWeek(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Int, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter {$0.dt > Int(tommorow)}
            .map {Int($0.dt)}
            .collect(8)
            .map {$0.min() ?? 0}
            .eraseToAnyPublisher()
    }
    
    static func minDaytimeTempForFiveDays(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Int, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter {$0.dt > Int(tommorow)}
            .map {Int($0.main.temp)}
            .collect(8)
            .map {$0.min() ?? 0}
            .eraseToAnyPublisher()
    }
    
    static func maxDaytimeTempForFiveDays(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Int, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter {$0.dt > Int(tommorow)}
            .map {Int($0.main.temp)}
            .collect(8)
            .map {$0.max() ?? 0}
            .eraseToAnyPublisher()
    }
    
    static func maxDaytimeRainForFiveDays(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Double, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter {$0.dt > Int(tommorow)}
            .map {$0.pop}
            .collect(8)
            .map {$0.max() ?? 0.0}
            .eraseToAnyPublisher()
    }
    
    static func dataForFivedayWeatherForecast(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<ForecastForFiveDaysModel, Never> {
        Publishers.Zip4(
            nameOfDayOfWeek(forecast),
            minDaytimeTempForFiveDays(forecast),
            maxDaytimeTempForFiveDays(forecast),
            maxDaytimeRainForFiveDays(forecast)
        )
        .map {ForecastForFiveDaysModel.List(dt: $0.0,
                                           minTemp: $0.1,
                                           maxTemp: $0.2,
                                           maxRain: $0.3)}
        .collect()
        .map {ForecastForFiveDaysModel(list: $0)}
        .eraseToAnyPublisher()
    }
    
    static func createFivedayWeatherForecast(_ data: Data) -> AnyPublisher<ForecastForFiveDaysModel, Error> {
        API.jsonDecodeDataFromURLSession(data)
            .flatMap(dataForFivedayWeatherForecast)
            .tryMap{$0}
            .eraseToAnyPublisher()
    }
    
}

extension ForecastModel {
    
    static func fetchWeatherForecastForCoordinatesOfCity(_ coord: ForecastTodayModel.CityCoord) -> AnyPublisher<Forecast, Error> {
        Publishers.Zip3(
            API.fetchURLForTodayWeatherForecast(coord),
            API.fetchURLForWeatherForecastForThreeHourIntervalsForFiveDays(coord),
            API.fetchURLForAirPollution(coord)
        )
        .flatMap{
            Publishers.Zip3(
                API.fetchDataFromURLSession($0.0),
                API.fetchDataFromURLSession($0.1),
                API.fetchDataFromURLSession($0.2)
            )
        }
        .flatMap{
            Publishers.Zip4(
                API.jsonDecodeDataFromURLSession($0.0),
                API.jsonDecodeDataFromURLSession($0.1),
                createFivedayWeatherForecast($0.1),
                API.jsonDecodeDataFromURLSession($0.2)
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
    static func fetchWeatherForecastForCoordinatesOfCities(_ coords: [ForecastTodayModel.CityCoord]) -> AnyPublisher<[Forecast], Error> {
        var indexes = [ForecastTodayModel.CityCoord: Int]()
        // bad
        for (index, entry) in coords.enumerated() {
            indexes[entry.self] = index
        }
        
        return coords
            .publisher
            .flatMap(fetchWeatherForecastForCoordinatesOfCity)
            .collect()
            .sort {a, b in
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
