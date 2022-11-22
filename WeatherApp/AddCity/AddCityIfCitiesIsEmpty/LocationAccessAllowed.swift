import SwiftUI
import CoreLocation

struct LocationAccessAllowed: View {
    @EnvironmentObject var model: ForecastViewModel
    let forecastForCities: [ForecastModel.Forecast]
    
    @Binding var isAddCity: Bool
    @State private var isAddCityView = false
    
    let lat, lon: Double
    
    private let manager = CLLocationManager()
    
    var body: some View {
        VStack  {
            Text("Add weather forecast for your location?")
                .padding()
                .background(.blue.opacity(0.7))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.top, 60)
            HStack {
                Button {
                    let coord = ForecastTodayModel.CityCoord(lat: lat, lon: lon)
                    DispatchQueue.global().sync {
                        model.weatherForecastForCoordinatesOfNewCity(coord)
                    }
                    DispatchQueue.global().sync {
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


