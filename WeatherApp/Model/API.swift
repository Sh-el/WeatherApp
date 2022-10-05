import Foundation
import Combine

struct API {
    enum RequestError: String, LocalizedError {
        case addressUnreachable
        case invalidRequest
        case decodingError
        case unknownError
        case noError
        
//        var errorDescription: String {
//            switch self {
//            case .addressUnreachable:
//                return "Bad URL"
//            case .invalidRequest:
//                return "Bad connect"
//            case .decodingError:
//                return "Bad Data"
//            case .unknownError:
//                return "Unknown Error. Restart App!"
//            case .noError:
//                return "No Error"
//                
//            }
//        }
    }
    
    enum EndPoint {
        static let forecastTodayURL = "https://api.openweathermap.org/data/2.5/weather?"
        static let forecastForFiveDaysThreeHoursURL = "https://api.openweathermap.org/data/2.5/forecast?"
        static let airPollutionURL = "http://api.openweathermap.org/data/2.5/air_pollution?"
        static let geocoding = "http://api.openweathermap.org/geo/1.0/direct?"
        
        static let apiKey = "06d1fe9aeaf87501637b6638e8a5dbbf"
    }
    
    
    static func fetchURLForTodayWeatherForecast(_ coord: ForecastTodayModel.CityCoord) -> AnyPublisher<URL, Error> {
        Just(coord)
            .tryMap {
                guard let url = URL(string: EndPoint.forecastTodayURL + "lat=\($0.lat)&lon=\($0.lon)" + "&limit=5" + "&appid=" + EndPoint.apiKey + "&units=metric")
                else {
                    throw  RequestError.addressUnreachable
                }
                return url
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchURLForWeatherForecastForThreeHourIntervalsForFiveDays(_ coord: ForecastTodayModel.CityCoord) -> AnyPublisher<URL, Error> {
        Just(coord)
            .tryMap {
                guard let url = URL(string: EndPoint.forecastForFiveDaysThreeHoursURL + "lat=\($0.lat)&lon=\($0.lon)" + "&limit=5" + "&appid=" + EndPoint.apiKey + "&units=metric")
                else {
                    throw  RequestError.addressUnreachable
                }
                return url
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchURLForAirPollution(_ coord: ForecastTodayModel.CityCoord) -> AnyPublisher<URL, Error> {
        Just(coord)
            .tryMap {
                guard let url = URL(string: EndPoint.airPollutionURL + "lat=\($0.lat)&lon=\($0.lon)" + "&limit=5" + "&appid=" + EndPoint.apiKey + "&units=metric")
                else {
                    throw  RequestError.addressUnreachable
                }
                return url
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchURLForGeocoding(_ city: String) -> AnyPublisher<URL, Error> {
        Just(city)
            .tryMap {
                guard let url = URL(string: EndPoint.geocoding + "q=" + $0 + "&limit=5" + "&appid=" + EndPoint.apiKey + "&units=metric")
                else {
                    throw  RequestError.addressUnreachable
                }
                return url
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchDataFromURLSession(_ url: URL) -> AnyPublisher<Data, Error> {
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .mapError {error -> Error in
                return RequestError.invalidRequest
            }
            .map(\.data)
            .eraseToAnyPublisher()
    }
    
    static func jsonDecodeDataFromURLSession<T: Decodable>(_ data: Data) -> AnyPublisher<T, Error> {
        let decoder = JSONDecoder()
        
        let dataTaskPublisher = Just(data)
            .tryMap {data -> T in
                do {
                    return try decoder.decode(T.self, from: data)
                }
                catch {
                    throw RequestError.decodingError
                }
            }
        return dataTaskPublisher
            .map{$0}
            .eraseToAnyPublisher()
    }

}



