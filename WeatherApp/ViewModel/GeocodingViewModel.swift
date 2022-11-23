import Foundation
import Combine

final class GeocodingViewModel: ObservableObject {
    typealias GeocodingAndError = Result<[GeocodingModel.Geocoding], Error>
    
    @Published var newCity = "" //input
    @Published var geocodingForNewCity: GeocodingAndError?
    
    static private func resultAndError(_ city: String) -> AnyPublisher<[GeocodingModel.Geocoding], Error> {
        Just(city)
            .flatMap{API.fetchURL(url: API.EndPoint.geocoding + $0)}
            .flatMap(API.fetchDataFromURLSession)
            .flatMap(API.decodeDataFromURLSession)
            .eraseToAnyPublisher()
    }
    
    init() {
        $newCity
//            .filter{!$0.isEmpty}
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map{$0.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!}
            .flatMap{GeocodingViewModel.resultAndError($0).asResultOptional()}
            .map{$0}
            .receive(on: DispatchQueue.main)
            .assign(to: &$geocodingForNewCity)
    }
}



