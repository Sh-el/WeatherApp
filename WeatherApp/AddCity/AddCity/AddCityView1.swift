import SwiftUI

struct AddCityView1: View {
    @EnvironmentObject var model: ForecastViewModel1
    
    var forecastForCities: [ForecastModel.Forecast]
    @Binding var isAddCityView: Bool
    @Binding var isAddCity: Bool
    
    init(isAddCityView: Binding<Bool>,
         isAddCity: Binding<Bool>,
         forecastForCities: [ForecastModel.Forecast]) {
        self._isAddCityView = isAddCityView
        self._isAddCity = isAddCity
        self.forecastForCities = forecastForCities
    }
    
    init(isAddCityView: Binding<Bool>,
         isAddCity: Binding<Bool>,
         selectedTab: Binding<ForecastTodayModel?>,
         forecastForCities: [ForecastModel.Forecast]) {
        self._isAddCityView = isAddCityView
        self._isAddCity = isAddCity
        self.forecastForCities = forecastForCities
    }
    
    var body: some View {
        Group{
            if let forecastForNewCity = model.forecastForNewCity {
                switch forecastForNewCity {
                case .success(let forecast):
                    ZStack(alignment: .top) {
                        VStack {
                            WeatherDescriptionView(forecastForCity: forecast)
                            Spacer()
                        }
                        HStack {
                            Button {
                                model.appendCity(forecast, forecastForCities)
                                model.weatherForecastForCoordinatesOfCities(model.loadCitiesCoord())
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
                    .background(BackgroundView1(forecastTodayForSelectedCity: forecast.forecastToday))
                    .foregroundColor(Constants.textColor)
                case .failure:
                    Text("Bad")
                }
            } else {
                LoadingWindowView1()
            }
        }
    }
}

