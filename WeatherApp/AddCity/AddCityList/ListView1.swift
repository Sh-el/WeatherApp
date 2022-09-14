
import SwiftUI

struct ListView1: View {
    @EnvironmentObject var model: ForecastViewModel1
    
    var forecastForCities: [ForecastModel.Forecast]
    var geocodingForNewCity: [GeocodingModel.Geocoding]
    @Binding var isAddCityView: Bool
    @Binding var isAddCity: Bool
    
    var body: some View {
        
        List(geocodingForNewCity, id: \.id) {geocodingForNewCity in
            Button {
                let coord = ForecastTodayModel.CityCoord(
                    lat: geocodingForNewCity.lat,
                    lon: geocodingForNewCity.lon)
                model.weatherForecastForCoordinatesOfNewCity(coord)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    isAddCityView = true
                }
            } label: {
                HStack {
                    Text(geocodingForNewCity.name)
                        .fontWeight(.thin)
                    Text(geocodingForNewCity.country)
                        .fontWeight(.thin)
                    Text(geocodingForNewCity.state ?? "")
                        .fontWeight(.thin)
                }
                .font(.headline)
                .opacity(0.9)
                .lineLimit(1)
            }
            .sheet(isPresented: $isAddCityView) {
                AddCityView1(isAddCityView: $isAddCityView,
                            isAddCity: $isAddCity,
                             forecastForCities: forecastForCities)
            }
            .listRowBackground(Color.black)
        }
        .scrollContentBackground(.hidden)
    }
}
