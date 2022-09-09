import SwiftUI

struct MainView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var body: some View {
        switch (model.coordForCities?.isEmpty, model.errorFetchForecast) {
        case (true, _):
            AddCityIfCitiesIsEmptyView()
        case (false, nil):
            LoadingWindowView()
        case (false, .noError):
            if let forecastForCities = model.forecastForCities,
               let firstElement = model.forecastForCities?.first?.forecastToday {
                Forecast(forecastForCities: forecastForCities, selectedTab: firstElement)
            }
        case (_, .invalidRequest):
            ErrorInvalidRequestForMainView()
        default:
            ErrorOtherForMainView()
        }
    }
}
