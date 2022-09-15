import SwiftUI

@main
struct WeatherAppApp: App {
    let  model = ForecastViewModel()
    
    init() {
        UITableView.appearance().backgroundColor = .black
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(model)
                .onReceive(model.timer) {_ in
                    model.weatherForecastForCoordinatesOfCities(model.loadCitiesCoord())
                }
        }
    }
}
