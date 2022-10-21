import SwiftUI
import CoreLocation

struct LocationAccessAllowed: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var forecastForCities: [ForecastModel.Forecast]
    @Binding var isAddCity: Bool
    @State private var isAddCityView = false
    var lat, lon: Double
    
    private let manager = CLLocationManager()
    
    var body: some View {
        VStack  {
            Text("Add weather forecast for your location?")
                .padding()
                .background(.blue.opacity(0.7))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.top, 40)
            HStack {
                Button {
                        let coord = ForecastTodayModel.CityCoord(lat: lat, lon: lon)
                        model.weatherForecastForCoordinatesOfNewCity(coord) // serial ?
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                isAddCityView = true
                        }
                } label: {
                    Text("Yes")
                        .addCityIfCitiesIsEmptyButtonModifier()
                }
                .sheet(isPresented: $isAddCityView) {
                    AddCityView(forecastForCities: forecastForCities)
                }
                Button {
                    isAddCity = true
                } label: {
                    Text("No")
                        .addCityIfCitiesIsEmptyButtonModifier()
                }
            }
        }
    }
}


