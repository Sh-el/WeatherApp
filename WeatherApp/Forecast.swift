import SwiftUI

struct Forecast: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var forecastForCities: [ForecastModel.Forecast]
    @State private var selectedTab: ForecastTodayModel?
    @State private var isAddCity = false
    @State private var isRemoveCity = false
    
    init(forecastForCities: [ForecastModel.Forecast]) {
        self.forecastForCities = forecastForCities
        self._selectedTab = State(initialValue: forecastForCities.first!.forecastToday)
    }
    
    var body: some View {
        TabView(selection: $selectedTab.animation(.easeInOut(duration: 1.0))) {
            ForEach(forecastForCities, id: \.id) {forecastForCity in
                ZStack(alignment: .top) {
                    ButtonRemoveCity(isRemoveCity: $isRemoveCity)
                    ButtonAddCity(isAddCity: $isAddCity)
                    WeatherDescriptionView(forecastForCity: forecastForCity)
                }
                .tag(Optional(forecastForCity.forecastToday))
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(BackgroundView(forecastTodayForSelectedCity: selectedTab!))
        .sheet(isPresented: $isAddCity) {
            AddCityListView(isAddCity: $isAddCity,
                             forecastForCities: forecastForCities,
                             selectedTab: $selectedTab)
        }
        .sheet(isPresented: $isRemoveCity) {
            RemoveCitiesView(forecastForCities: forecastForCities,
                             selectedTab: $selectedTab)
        }
    }
}

