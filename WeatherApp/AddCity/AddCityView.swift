import SwiftUI

struct AddCityView: View {
    @EnvironmentObject var model: ForecastViewModel
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
            ZStack(alignment: .top) {
                VStack {
                    WeatherDescriptionView(forecastForCity: forecastForNewCity)
                    Spacer()
                }
                HStack {
                    Button {
                        model.appendCity(forecastForNewCity)
                        DispatchQueue.global(qos: .userInteractive).async {
                            model.saveCities()
                        }
                        selectedTab = forecastForNewCity.forecastToday
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
            .background(BackgroundView(forecastTodayForSelectedCity: forecastForNewCity.forecastToday))
            .foregroundColor(Constants.textColor)
        }
        else {
            LoadingWindowView()
        }
    }
    
}

//struct CityAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCityView()
//    }
//}
