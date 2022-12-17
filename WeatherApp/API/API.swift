import Foundation
import Combine

struct API {
    enum RequestError: Error {
        case addressUnreachable
        case invalidRequest
        case decodingError
        case unknownError
        case timeOut
        case noError
        case loadDataError
    }
  
    static func fetch(url: String) -> AnyPublisher<URL, Error> {
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
    
    static func fetchData(_ url: URL) -> AnyPublisher<Data, Error> {
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
    
    static func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, Error> {
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
    
    static func load<T: Decodable>(url: String) -> AnyPublisher<T, Error> {
        Just(url)
            .tryMap{value in
                do {
                    if let url = FileManager.documentURL?.appendingPathComponent(value) {
                        return try Data(contentsOf: url)
                    } else {
                        throw RequestError.addressUnreachable
                    }
                } catch {
                    throw RequestError.loadDataError
                }
            }
            .flatMap(API.decode)
            .eraseToAnyPublisher()
    }
}



