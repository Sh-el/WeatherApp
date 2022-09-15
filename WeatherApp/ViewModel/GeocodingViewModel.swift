import Foundation
import Combine

final class GeocodingViewModel: ObservableObject {
    typealias GeocodingAndError = Result<[GeocodingModel.Geocoding], Error>
    
    @Published var newCity = "" //input
    @Published var geocodingForNewCity: GeocodingAndError? = nil
    
    func resultAndError(_ city: String) ->AnyPublisher<[GeocodingModel.Geocoding], Error> {
        Just(city)
            .flatMap(API.fetchURLForGeocoding)
            .flatMap(API.fetchDataFromURLSession)
            .flatMap(API.jsonDecodeDataFromURLSession)
            .eraseToAnyPublisher()
    }
    
    private lazy var fetchGeocodingForCityPublisher: AnyPublisher<GeocodingAndError?, Never> = {
        $newCity
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map {$0.replacingOccurrences(of: " ", with: "%20")}
            .flatMap{self.resultAndError($0).asResultOptional()}
            .eraseToAnyPublisher()
    }()
  
    init() {
        fetchGeocodingForCityPublisher
            .map{$0}
            .print()
            .receive(on: DispatchQueue.main)
            .assign(to: &$geocodingForNewCity)
    }
    
}



