import SwiftUI
import MapKit
import CoreLocation

struct AddCityIfCitiesIsEmptyView: View {
    @EnvironmentObject var model: ForecastViewModel
    @ObservedObject private var locationManager = LocationManager()
    
    var forecastForCities: [ForecastModel.Forecast]
    @State private var isAddCityView = false
    @State private var isAddCity = false
    private let manager = CLLocationManager()
    
    var body: some View {
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate :  CLLocationCoordinate2D()
       return ZStack(alignment: .top) {
            switch manager.authorizationStatus {
            case .denied:
                LocationAccessDenied(isAddCity: $isAddCity)
            default:
                MapViewForYourCoordinate()
                LocationAccessAllowed(forecastForCities: forecastForCities,
                                      isAddCity: $isAddCity,
                                      isAddCityView: $isAddCityView,
                                      lat: coordinate.latitude,
                                      lon: coordinate.longitude)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $isAddCity) {
            AddCityListView(isAddCity: $isAddCity, forecastForCities: forecastForCities)
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


