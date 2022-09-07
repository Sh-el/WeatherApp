import SwiftUI

struct Forecast: View {
    @EnvironmentObject var model: ForecastViewModel
    
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
            .background(BackgroundView(forecastTodayForSelectedCity: selectedTab!))
            .sheet(isPresented: $isAddCity) {
                AddCityListView(isAddCity: $isAddCity, selectedTab: $selectedTab)
            }
            .actionSheet(isPresented: $isRemoveCity) {
                ActionSheet(
                    title: Text("Remove Cities"),
                    message: Text("Remove \(selectedTab!.name)"),
                    buttons: [
                        .cancel(Text("Not Now")),
                        .default(Text("Remove")) {
                            model.removeCity(selectedTab!)
                            if let firstElement = model.forecastForCities?.first?.forecastToday {
                                selectedTab = firstElement
                            }
                            DispatchQueue.global(qos: .userInteractive).async {
                                model.saveCities()
                            }
                        }
                    ]
                )
            }
    }
}

//struct Forecast_Previews: PreviewProvider {
//    static var previews: some View {
//        Forecast()
//    }
//}
