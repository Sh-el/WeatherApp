import SwiftUI

struct AddView: View {
    @EnvironmentObject var model: ForecastViewModel
    let forecastForCities: [ForecastModel.Forecast]
    let forecast: ForecastModel.Forecast
    @Binding var selectedTab: ForecastTodayModel?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                WeatherDescriptionView(forecastForCity: forecast)
                Spacer()
            }
            HStack {
                Button {
                    model.appendCity(forecast, forecastForCities)
//                    model.weatherForecast1(model.loadCitiesCoord1())
                    model.weatherForecast2()
                    selectedTab = forecast.forecastToday
                    dismiss()
                } label: {
                    Text("Add")
                        .padding(.top, 10)
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .padding(.top, 10)
                }
            }
            .font(.headline)
            .padding(5)
        }
        .background(BackgroundView(forecastTodayModel: forecast.forecastToday))
        .foregroundColor(Constants.textColor)
    }
}

