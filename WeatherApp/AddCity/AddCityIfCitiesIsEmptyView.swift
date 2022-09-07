import SwiftUI
import MapKit
import CoreLocation

struct AddCityIfCitiesIsEmptyView: View {
    @EnvironmentObject var model: ForecastViewModel
    @ObservedObject private var locationManager = LocationManager()
    @State private var isAddCityView = false
    @State private var isAddCity = false
    private let statusLocationAccess = CLLocationManager.authorizationStatus()
    
    var body: some View {
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate :  CLLocationCoordinate2D()
        
        return ZStack(alignment: .top) {
            if statusLocationAccess == .denied {
                ZStack {
                    Image("Clear")
                VStack {
                    Text("Access for your location is denied")
                    Text("Enter location")
                    Button {
                        isAddCity = true
                    } label: {
                        Text("Ok")
                            .addCityIfCitiesIsEmptyButtonModifier()
                    }
                }
                .multilineTextAlignment(.center)
                .font(.headline)
                .foregroundColor(Color(hue: 0.593, saturation: 0.084, brightness: 0.892))
                .padding(.vertical, 3.0)
                }
            }
            else {
                MapViewForYourCoordinate()
                VStack {
                    Text("Add weather forecast for your location?")
                        .padding()
                        .background(.blue.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    HStack {
                        Button {
                            if statusLocationAccess == .denied {
                                isAddCity = true
                            }
                            else {
                                let coord = ForecastTodayModel.CityCoord(
                                    lat: coordinate.latitude,
                                    lon: coordinate.longitude)
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
                            if model.errorFetchForecast == .invalidRequest {
                                ErrorInvalidRequestForAddCityView()
                            } else {
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
        .ignoresSafeArea()
        .sheet(isPresented: $isAddCity) {
            AddCityListView(isAddCity: $isAddCity)
        }
    }
    
    private func settingOpener() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}

//struct AddCityifCitiesIsEmptyView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCityIfCitiesIsEmptyView()
//    }
//}
