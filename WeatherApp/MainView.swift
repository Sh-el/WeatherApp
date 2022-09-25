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
            ErrorView(error: error, color: .black)
        default:
            LoadingWindowView(color: .blue.opacity(0.7))
        }
        
//        FetchResult(model.forecastForCities, color: .blue.opacity(0.7)) {forecast  in
//            Group {
//                if forecast.isEmpty {
//                    AddCityIfCitiesIsEmptyView(forecastForCities: forecast as! [ForecastModel.Forecast])
//                } else {
//                    Forecast(forecastForCities: forecast as! [ForecastModel.Forecast])
//                }
//            }
//        } failure: { error in
//            ErrorView(error: error, color: .black)
//        }
        
    }
    
    
}

extension View {
    
    @ViewBuilder
    func FetchResult<T>(_ result: Result<T, Error>?, color: Color, completion: (Any) -> some View, failure: (Error) -> some View) -> some View {
        switch result {
        case .success(let success):
            completion(success)
        case .failure(let error):
            failure(error)
        case .none:
            LoadingWindowView(color: color)
        }
    }
}
