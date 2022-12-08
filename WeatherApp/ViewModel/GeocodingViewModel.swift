import Foundation
import Combine

final class GeocodingViewModel: ObservableObject {
    typealias GeocodingAndError = Result<[GeocodingModel.Geocoding], Error>
    
    @Published var newCity = "" //input
    @Published var geocodingForNewCity: GeocodingAndError?
    
    static private func geocoding(_ city: String) -> AnyPublisher<[GeocodingModel.Geocoding], Error> {
        Just(city)
            .flatMap{API.fetch(url: ForecastModel.EndPoint.geocoding.url + $0)}
            .flatMap(API.fetchData)
            .flatMap(API.decode)
            .eraseToAnyPublisher()
    }
    
    init() {
        $newCity
//            .filter{!$0.isEmpty}
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map{$0.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!}
            .flatMap{GeocodingViewModel.geocoding($0).asResult()}
            .map{$0}
            .receive(on: DispatchQueue.main)
            .assign(to: &$geocodingForNewCity)
    }
}



