import SwiftUI

struct RemoveCitiesView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var forecastForCities: [ForecastModel.Forecast]
    @Binding var selectedTab: ForecastTodayModel?
  
    var body: some View {
        List(forecastForCities, id: \.id) {forecastForCity in
            HStack {
                Button {
                    DispatchQueue.global(qos: .userInteractive).sync {
                        model.removeCity(forecastForCity.forecastToday, forecastForCities)
                    }
                    DispatchQueue.global(qos: .userInteractive).sync {
                        model.weatherForecastForCoordinatesOfCities(model.loadCitiesCoord())
                    }
                    if let selectedTab = model.selectedTab(forecastForCity.forecastToday, forecastForCities) {
                        self.selectedTab = selectedTab
                    }
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
                    .padding(.leading, 10)
            }
            .font(.title3)
            .foregroundColor(.white)
            .opacity(0.9)
            .lineLimit(1)
            .padding(.bottom, 20)
            .listRowBackground(Color.black)
        }
        .scrollContentBackground(.hidden)
        .background(.black)
    }
}

