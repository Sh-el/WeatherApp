import SwiftUI

struct AddView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var forecastForCities: [ForecastModel.Forecast]
    var forecast: ForecastModel.Forecast
    @Binding var selectedTab: ForecastTodayModel?
    @Binding var isAddCityView: Bool
    @Binding var isAddCity: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                WeatherDescriptionView(forecastForCity: forecast)
                Spacer()
            }
            HStack {
                Button {
                    model.appendCity(forecast, forecastForCities)
                    model.weatherForecastForCoordinatesOfCities(model.loadCitiesCoord())
                    selectedTab = forecast.forecastToday
                    isAddCityView = false
                    isAddCity = false
                } label: {
                    Text("Add")
                        .padding(.top, 10)
                }
                Spacer()
                Button {
                    isAddCityView = false
                } label: {
                    Text("Cancel")
                        .padding(.top, 10)
                }
            }
            .font(.headline)
            .padding(5)
        }
        .background(BackgroundView(forecastTodayForSelectedCity: forecast.forecastToday))
        .foregroundColor(Constants.textColor)
    }
}

