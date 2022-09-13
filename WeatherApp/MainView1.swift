import SwiftUI

struct MainView1: View {
    @EnvironmentObject var model: ForecastViewModel1
    
    var body: some View {
        switch model.forecastForCities {
        case .success(let forecast):
            if forecast.isEmpty {
                AddCityIfCitiesIsEmptyView1(forecastForCities: forecast)
            } else {
                Forecast1(forecastForCities: forecast)
            }
        case .failure(let error):
            ErrorView(error: error)
        default:
            LoadingWindowView1()
        }
    }
    
}
