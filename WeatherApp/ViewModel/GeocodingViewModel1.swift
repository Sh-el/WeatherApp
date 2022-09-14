import Foundation
import Combine

final class GeocodingViewModel1: ObservableObject {
    typealias GeocodingAndError = Result<[GeocodingModel.Geocoding], Error>
    
    @Published var newCity = ""
    
    @Published var geocodingForNewCity: Result<[GeocodingModel.Geocoding], Error>? = nil
    @Published var errorFetchForecast: API.RequestError? = nil
    
    private lazy var fetchGeocodingForCityPublisher: AnyPublisher<String, Never> = {
        $newCity
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map {$0.replacingOccurrences(of: " ", with: "%20")}
            .eraseToAnyPublisher()
    }()
    
    init() {
        
        fetchGeocodingForCityPublisher
            .flatMap(API.fetchURLForGeocoding)
            .flatMap(API.fetchDataFromURLSession1)
            .flatMap(API.jsonDecodeDataFromURLSession1)
            .asResult1()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: &$geocodingForNewCity)
      
    }
    
}



