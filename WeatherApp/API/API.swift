import Foundation
import Combine

struct API {
    enum RequestError: String, LocalizedError {
        case addressUnreachable
        case invalidRequest
        case decodingError
        case unknownError
        case timeOut
        case noError
    }
    
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
   
    static func fetchURL(url: String) -> AnyPublisher<URL, Error> {
        Just(url)
            .tryMap {
                guard let url = URL(string: $0)
                else {
                    throw RequestError.addressUnreachable
                }
                return url
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchDataFromURLSession(_ url: URL) -> AnyPublisher<Data, Error> {
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .mapError{error -> Error in
                return RequestError.invalidRequest
            }
            .map(\.data)
            .timeout(.seconds(5.0),
                     scheduler: DispatchQueue.main,
                     customError: {RequestError.timeOut})
            .eraseToAnyPublisher()
    }
    
    static func decodeDataFromURLSession<T: Decodable>(_ data: Data) -> AnyPublisher<T, Error> {
        let decoder = JSONDecoder()
        
        let dataTaskPublisher = Just(data)
            .tryMap{data -> T in
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



