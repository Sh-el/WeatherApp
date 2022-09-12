import SwiftUI

struct AddCityView1: View {
    @EnvironmentObject var model: ForecastViewModel1
    
    @Binding var isAddCityView: Bool
    @Binding var isAddCity: Bool
    @Binding var selectedTab: ForecastTodayModel?
    
    init(isAddCityView: Binding<Bool>, isAddCity: Binding<Bool>) {
        self._isAddCityView = isAddCityView
        self._isAddCity = isAddCity
        self._selectedTab = .constant(nil)
    }
    
    init(isAddCityView: Binding<Bool>, isAddCity: Binding<Bool>, selectedTab: Binding<ForecastTodayModel?>) {
        self._isAddCityView = isAddCityView
        self._isAddCity = isAddCity
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        
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
//                            model.appendCity(forecast)
//                            DispatchQueue.global(qos: .userInteractive).async {
//                                model.saveCities()
//                            }
//                            selectedTab = forecast.forecastToday
//                            isAddCityView = false
//                            isAddCity = false
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
                
                
            case .failure(let error):
                Text("Bad")
            }
        } else {
            LoadingWindowView1()
        }
        
        
    }
    
}

//struct CityAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCityView()
//    }
//}
