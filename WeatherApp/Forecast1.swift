import SwiftUI

struct Forecast1: View {
    @EnvironmentObject var model: ForecastViewModel1
    
    var forecastForCities: [ForecastModel.Forecast]
    @State private var isAddCity = false
    @State private var isRemoveCity = false
    @State var selectedTab: ForecastTodayModel
    
    init(forecastForCities: [ForecastModel.Forecast]) {
        UITableView.appearance().backgroundColor = .clear
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
                .tag(forecastForCity.forecastToday)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(BackgroundView1(forecastTodayForSelectedCity: selectedTab))
        .sheet(isPresented: $isAddCity) {
            AddCityListView1(isAddCity: $isAddCity, forecastForCities: forecastForCities)
        }
        .sheet(isPresented: $isRemoveCity) {
            RemoveCitiesView(forecastForCities: forecastForCities)
        }
    }
}

