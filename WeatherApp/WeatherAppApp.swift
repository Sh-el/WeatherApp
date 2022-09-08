import SwiftUI

@main
struct WeatherAppApp: App {
    let  model = ForecastViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView1()
                .environmentObject(model)
                .onReceive(model.timer) {_ in
                    model.forecastCities()
                }
        }
    }
}
