import Foundation
import Combine

struct ForecastModel {
    
    struct Forecast {
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
    
    static func minDailyTempForFiveDays(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Int, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter {$0.dt > Int(tommorow)}
            .map {Int($0.main.temp)}
            .collect(8)
            .map {$0.min() ?? 0}
            .eraseToAnyPublisher()
    }
    
    static func maxDailyTempForFiveDays(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Int, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter {$0.dt > Int(tommorow)}
            .map {Int($0.main.temp)}
            .collect(8)
            .map {$0.max() ?? 0}
            .eraseToAnyPublisher()
    }
    
    static func maxDailyRainForFiveDays(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<Double, Never> {
        let tommorow = Date().dayAfterMidnight.timeIntervalSince1970
        return forecast.list
            .publisher
            .filter {$0.dt > Int(tommorow)}
            .map {$0.pop}
            .collect(8)
            .map {$0.max() ?? 0.0}
            .eraseToAnyPublisher()
    }
    
    static func dataFiveDays(_ forecast: ForecastForFiveDaysThreeHoursModel) -> AnyPublisher<ForecastForFiveDaysModel, Never> {
        Publishers.Zip4(
            nameOfDayOfWeek(forecast),
            minDailyTempForFiveDays(forecast),
            maxDailyTempForFiveDays(forecast),
            maxDailyRainForFiveDays(forecast)
        )
        .map{ForecastForFiveDaysModel.List(dt: $0.0,
                                           minTemp: $0.1,
                                           maxTemp: $0.2,
                                           maxRain: $0.3)}
        .collect()
        .map {ForecastForFiveDaysModel(list: $0)}
        .eraseToAnyPublisher()
    }
    
    static func fetchForecastForFiveDays(_ url: URL) -> AnyPublisher<ForecastForFiveDaysModel, Error> {
        API.fetchForecastFromURL(url)
            .flatMap(dataFiveDays)
            .tryMap{$0}
            .eraseToAnyPublisher()
    }
    
}

extension ForecastModel {
    
    static func fetchForecastForCityCoord(_ coord: ForecastTodayModel.CityCoord) -> AnyPublisher<Forecast, Error> {
        Publishers.Zip3(
            API.fetchURLForForecastToday(coord),
            API.fetchURLForFiveDaysThreeHours(coord),
            API.fetchURLForAirPollution(coord)
        )
        .flatMap{
            Publishers.Zip4(
                API.fetchForecastFromURL($0.0),
                API.fetchForecastFromURL($0.1),
                fetchForecastForFiveDays($0.1),
                API.fetchForecastFromURL($0.2)
            )
        }
        .map {
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
    static func fetchForecastForCitiesCoord(_ coords: [ForecastTodayModel.CityCoord]) -> AnyPublisher<[Forecast], Error> {
        var indexes = [ForecastTodayModel.CityCoord: Int]()
        // bad
        for (index, entry) in coords.enumerated() {
            indexes[entry.self] = index
        }
        
        return coords
            .publisher
            .flatMap(fetchForecastForCityCoord)
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
