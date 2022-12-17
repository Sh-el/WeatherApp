import SwiftUI

struct MainView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var body: some View {
        FetchResult(model.forecastForCities) {forecastForCities in
            if forecastForCities.isEmpty {
                AddCityIfCitiesIsEmptyView(forecastForCities: forecastForCities)
            } else {
                ForecastView(forecastForCities: forecastForCities)
            }
        } failure: {error in
            ErrorView(error: error, color: .black)
        } none: {
            LoadingWindowView(color: .blue.opacity(0.7))
        }
    }
}

extension View {
    @ViewBuilder
    func FetchResult<T>(_ result: Result<T, Error>?,
                        @ViewBuilder completion: (T) -> some View,
                        @ViewBuilder failure: (Error) -> some View,
                        @ViewBuilder none: () -> some View) -> some View {
        switch result {
        case .success(let success):
            completion(success)
        case .failure(let error):
            failure(error)
        case .none:
            none()
        }
    }
    
    
}
