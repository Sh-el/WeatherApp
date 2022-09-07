import SwiftUI

struct ForecastForTodayDetailsView: View {
    var forecastForCity: ForecastModel.Forecast
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 150, maximum: 250))]
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            Group {
                VisibilityView(forecastTodayForCity: forecastForCity.forecastToday)
                PressureView(forecastTodayForCity: forecastForCity.forecastToday)
                HumidityView(forecastTodayForCity: forecastForCity.forecastToday)
                CloudinessView(forecastTodayForCity: forecastForCity.forecastToday)
            }
            .aspectRatio(1/1, contentMode: .fit)
        }
        .padding(5)
        .foregroundColor(Constants.textColor)
    }
}

//struct ForecastForDayDetailsView1_Previews: PreviewProvider {
//    static var previews: some View {
//        ForecastForTodayDetailsView(forecastForCity: ForecastModel.Forecast.empty)
//            .previewInterfaceOrientation(.portrait)
//    }
//}
