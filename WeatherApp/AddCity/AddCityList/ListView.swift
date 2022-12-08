
import SwiftUI

struct ListView: View {
    @EnvironmentObject var model: ForecastViewModel
    let forecastForCities: [ForecastModel.Forecast]
    let geocodingForNewCity: [GeocodingModel.Geocoding]
    
    @Binding var selectedTab: ForecastTodayModel?
    @State private var isAddCityView = false
    
    var body: some View {
        if !geocodingForNewCity.isEmpty {
            List(geocodingForNewCity, id: \.id) {geocodingForNewCity in
                Button {
                    let coord = ForecastTodayModel.CityCoord(
                        lat: geocodingForNewCity.lat,
                        lon: geocodingForNewCity.lon)
                    DispatchQueue.global().sync {
                        model.weatherForecastForNewCity(coord)
                    }
                    DispatchQueue.global().sync {
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
                    AddCityView(selectedTab: $selectedTab,
                                forecastForCities: forecastForCities)
                }
                .listRowBackground(Color.black)
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
        } else {
            DecodingError()
        }
    }
}
