import SwiftUI

struct MainView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var body: some View {
        if model.isCitiesEmpty() {
            AddCityIfCitiesIsEmptyView()
        } else {
            switch model.errorFetchForecast {
            case nil:
                LoadingWindowView()
            case .noError:
                if let forecastForCities = model.forecastForCities,
                   let firstElement = model.forecastForCities?.first?.forecastToday {
                    Forecast(forecastForCities: forecastForCities, selectedTab: firstElement)
                }
            case .invalidRequest:
                ErrorInvalidRequestForMainView()
            default:
                ErrorOtherMainView()
            }
        }
    }
}

