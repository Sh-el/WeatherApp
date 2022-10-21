import SwiftUI

struct AddCityView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var forecastForCities: [ForecastModel.Forecast]
    @Binding var selectedTab: ForecastTodayModel?
    
    init(forecastForCities: [ForecastModel.Forecast]) {
        self.forecastForCities = forecastForCities
        self._selectedTab = .constant(nil)
    }
    
    init(selectedTab: Binding<ForecastTodayModel?>,
         forecastForCities: [ForecastModel.Forecast]) {
        self.forecastForCities = forecastForCities
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        switch model.forecastForNewCity {
        case .success(let forecast):
            AddView(forecastForCities: forecastForCities,
                    forecast: forecast,
                    selectedTab: $selectedTab)
        case .failure(let error):
            ErrorView(error: error, color: .black)
        default:
            LoadingWindowView(color: .blue.opacity(0.7))
        }
    }
}

