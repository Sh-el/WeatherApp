import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject var  model = ForecastViewModel()
    
    init() {
        UITableView.appearance().backgroundColor = .black
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(model)
                .onReceive(model.timer) {_ in
                //    model.weatherForecast1(model.loadCitiesCoord1())
                    model.weatherForecast2()
                }
        }
    }
}
