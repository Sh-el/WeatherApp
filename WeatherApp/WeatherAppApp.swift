import SwiftUI

@main
struct WeatherAppApp: App {
    let  model = ForecastViewModel1()
    
    var body: some Scene {
        WindowGroup {
            MainView1()
                .environmentObject(model)
                .onReceive(model.timer) {_ in
                    model.weatherForecastForCoordinatesOfCities(model.loadCitiesCoord())
                }
        }
    }
}
