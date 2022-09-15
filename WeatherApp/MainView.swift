import SwiftUI

struct MainView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var body: some View {
        switch model.forecastForCities {
        case .success(let forecast):
            if forecast.isEmpty {
                AddCityIfCitiesIsEmptyView(forecastForCities: forecast)
            } else {
                Forecast(forecastForCities: forecast)
            }
        case .failure(let error):
            ErrorView(error: error)
        default:
            LoadingWindowView()
        }
    }
    
}
