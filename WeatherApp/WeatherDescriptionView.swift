import SwiftUI

struct WeatherDescriptionView: View {
    var forecastForCity: ForecastModel.Forecast
    
    var body: some View {
        VStack {
            ForecastTodayView(forecastTodayForCity: forecastForCity.forecastToday)
            ScrollView(showsIndicators: false) {
                ForecastForFiveDaysThreeHoursView(forecastForCity: forecastForCity)
                ForecastForFiveDaysView(forecastForCity: forecastForCity)
                AirPollutionView(forecastForCity: forecastForCity)
                ForecastForTodayDetailsView(forecastForCity: forecastForCity)
            }
        }
    }
}





