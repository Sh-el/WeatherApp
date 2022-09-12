import SwiftUI

struct MainView1: View {
    @EnvironmentObject var model: ForecastViewModel1
    
    var body: some View {
        if let forecastForCities = model.forecastForCities {
            switch forecastForCities {
            case .success(let forecast):
                Forecast1(forecastForCities: forecast,
                         selectedTab: forecast.first?.forecastToday)
            case .failure(let error):
                if case API.RequestError.invalidRequest = error {
                    ErrorInvalidRequestForMainView()
                }
            }
        } else {
            LoadingWindowView1()
        }
        
        //        switch (model.coordForCities?.isEmpty, model.errorFetchForecast) {
        //        case (true, _):
        //            AddCityIfCitiesIsEmptyView()
        //        case (false, nil):
        //            LoadingWindowView()
        //        case (false, .noError):
        //            if let forecastForCities = model.forecastForCities,
        //               let firstElement = model.forecastForCities?.first?.forecastToday {
        //                Forecast(forecastForCities: forecastForCities, selectedTab: firstElement)
        //            }
        //        case (_, .invalidRequest):
        //            ErrorInvalidRequestForMainView()
        //        default:
        //            ErrorOtherForMainView()
        //        }
        
    }
}
