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
                        Text(selectedTab?.name ?? "")
                        ButtonRemoveCity(isRemoveCity: $isRemoveCity)
                        ButtonAddCity(isAddCity: $isAddCity)
                        WeatherDescriptionView(forecastForCity: forecastForCity)
                    }
                    
                    .tag(Optional(forecastForCity.forecastToday))
                }
            }
            
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .background(Image("Clear"))
//            .background(BackgroundView1(forecastTodayForSelectedCity: selectedTab!))
            .sheet(isPresented: $isAddCity) {
                AddCityListView1(isAddCity: $isAddCity,
                                 selectedTab: $selectedTab,
                                 forecastForCities: forecastForCities)
            }
            .actionSheet(isPresented: $isRemoveCity) {
                ActionSheet(
                    title: Text("Remove Cities"),
                    message: Text("Remove \(selectedTab?.name ?? "")"),
                    buttons: [
                        .cancel(Text("Not Now")),
                        .default(Text("Remove")) {
                            if let selectedTab = selectedTab {
                                model.removeCity(selectedTab, forecastForCities)
                                model.weatherForecastForCoordinatesOfCities(model.loadCitiesCoord())
                            }
                        }
                    ]
                )
            }
    }
}

