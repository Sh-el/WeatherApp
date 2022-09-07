import Foundation
import Combine

final class NewCityGeocodingListViewModel: ObservableObject {
    typealias GeocodingAndError = Result<[GeocodingModel.Geocoding], Error>
    
    @Published var newCity = ""
    
    @Published var geocodingForNewCity: [GeocodingModel.Geocoding]? = nil
    @Published var errorFetchForecast: API.RequestError? = nil
    
    private lazy var fetchGeocodingForCityPublisher: AnyPublisher<GeocodingAndError, Never> = {
        $newCity
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map {$0.replacingOccurrences(of: " ", with: "%20")}
            .flatMap(API.fetchURLForGeocoding)
            .replaceError(with: URL(string: "a")!) //bad
            .flatMap {API.fetchForecastFromURL($0).asResult()}
            .share()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()
    
    init() {
        
        fetchGeocodingForCityPublisher
            .map {result in
                switch result {
                case .failure:
                    return nil
                case .success(let geocoding):
                    return geocoding
                }
            }
            .assign(to: &$geocodingForNewCity)
        
        fetchGeocodingForCityPublisher
            .map {result in
                switch result {
                case .failure(let error):
                    if case API.RequestError.addressUnreachable = error {
                        return API.RequestError.addressUnreachable}
                    else if case API.RequestError.invalidRequest = error {
                        return API.RequestError.invalidRequest}
                    else if case API.RequestError.decodingError = error {
                        return API.RequestError.decodingError}
                    else {return API.RequestError.decodingError}
                case .success:
                    return API.RequestError.noError
                }
            }
            .assign(to: &$errorFetchForecast)
    }
    
}



