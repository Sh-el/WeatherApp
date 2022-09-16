import SwiftUI

struct AddCityView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var forecastForCities: [ForecastModel.Forecast]
    @Binding var selectedTab: ForecastTodayModel?
    @Binding var isAddCityView: Bool
    @Binding var isAddCity: Bool
    
    init(isAddCityView: Binding<Bool>,
         isAddCity: Binding<Bool>,
         forecastForCities: [ForecastModel.Forecast]) {
        self._isAddCityView = isAddCityView
        self._isAddCity = isAddCity
        self.forecastForCities = forecastForCities
        self._selectedTab = .constant(nil)
    }
    
    init(isAddCityView: Binding<Bool>,
         isAddCity: Binding<Bool>,
         selectedTab: Binding<ForecastTodayModel?>,
         forecastForCities: [ForecastModel.Forecast]) {
        self._isAddCityView = isAddCityView
        self._isAddCity = isAddCity
        self.forecastForCities = forecastForCities
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        switch model.forecastForNewCity {
        case .success(let forecast):
            AddView(forecastForCities: forecastForCities,
                    forecast: forecast,
                    selectedTab: $selectedTab,
                    isAddCityView: $isAddCityView,
                    isAddCity: $isAddCity)
        case .failure(let error):
            ErrorView(error: error, color: .black)
        default:
            LoadingWindowView(color: .blue.opacity(0.7))
        }
    }
}

