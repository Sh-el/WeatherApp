import SwiftUI
import CoreLocation

struct LocationAccessAllowed: View {
    @EnvironmentObject var model: ForecastViewModel
    
    @Binding var isAddCity: Bool
    @Binding var isAddCityView: Bool
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
                    switch manager.authorizationStatus {
                    case .denied:
                        isAddCity = true
                    default:
                        let coord = ForecastTodayModel.CityCoord(lat: lat, lon: lon)
                        model.forecastNewCity(coord)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isAddCityView = true
                        }
                    }
                } label: {
                    Text("Yes")
                        .addCityIfCitiesIsEmptyButtonModifier()
                }
                .sheet(isPresented: $isAddCityView) {
                    switch model.errorFetchForecast {
                    case .invalidRequest:
                        ErrorInvalidRequestForAddCityView()
                    default:
                        AddCityView(isAddCityView: $isAddCityView, isAddCity: $isAddCity)
                    }
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


