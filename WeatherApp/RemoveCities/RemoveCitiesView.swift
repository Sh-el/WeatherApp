import SwiftUI

struct RemoveCitiesView: View {
    @EnvironmentObject var model: ForecastViewModel1
    var forecastForCities: [ForecastModel.Forecast]
    
    var body: some View {
        List(forecastForCities, id: \.id) {forecastForCity in
            HStack {
                Button {
                    model.removeCity(forecastForCity.forecastToday, forecastForCities)
                    model.weatherForecastForCoordinatesOfCities(model.loadCitiesCoord())
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .padding(.trailing, 10)
                }
                Text(forecastForCity.forecastToday.name)
                    .fontWeight(.regular)
                Text(forecastForCity.forecastToday.sys.country)
                    .fontWeight(.regular)
                Spacer()
                Text("\(String(Int(forecastForCity.forecastToday.main.temp))) \u{2103}")
                    .fontWeight(.bold)
            }
            .font(.title3)
            .foregroundColor(.white)
            .opacity(0.9)
            .lineLimit(1)
            .listRowBackground(Color.black)
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
    }
}

