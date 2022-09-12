import SwiftUI

struct Forecast1: View {
    @EnvironmentObject var model: ForecastViewModel1
    
    var forecastForCities: [ForecastModel.Forecast]
    @State private var isAddCity = false
    @State private var isRemoveCity = false
    @State var selectedTab: ForecastTodayModel?
    
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
            .background(BackgroundView1(forecastTodayForSelectedCity: selectedTab!))
            .sheet(isPresented: $isAddCity) {
                AddCityListView1(isAddCity: $isAddCity, selectedTab: $selectedTab)
            }
            .actionSheet(isPresented: $isRemoveCity) {
                ActionSheet(
                    title: Text("Remove Cities"),
                    message: Text("Remove \(selectedTab!.name)"),
                    buttons: [
                        .cancel(Text("Not Now")),
                        .default(Text("Remove")) {
                            model.removeCity(removeCityModel: selectedTab!, forecastForCities: forecastForCities)
                            model.weatherForecastForCoordinatesOfCities(model.loadCitiesCoord())
                            if let firstElement = forecastForCities.first?.forecastToday {
                                selectedTab = firstElement
                            }
                        }
                    ]
                )
            }
    }
}

