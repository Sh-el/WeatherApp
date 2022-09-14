import SwiftUI

struct AddCityListView1: View {
    @EnvironmentObject var model: ForecastViewModel1
    @StateObject var newCityGeocodingList = GeocodingViewModel()
    
    var forecastForCities: [ForecastModel.Forecast]
    @State private var isAddCityView = false
    @Binding var isAddCity: Bool
    
    init(isAddCity: Binding<Bool>, selectedTab: Binding<ForecastTodayModel?>, forecastForCities: [ForecastModel.Forecast]) {
        UITableView.appearance().backgroundColor = .clear
        self._isAddCity = isAddCity
        self.forecastForCities = forecastForCities
    }
    
    init(isAddCity: Binding<Bool>, forecastForCities: [ForecastModel.Forecast]) {
        UITableView.appearance().backgroundColor = .clear
        self._isAddCity = isAddCity
        self.forecastForCities = forecastForCities
    }
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("", text: $newCityGeocodingList.newCity)
                        .accentColor(.white)
                }
                .padding()
                .font(.title3)
                .frame(width: 300, height: 50)
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
                if let geocodingForNewCity = newCityGeocodingList.geocodingForNewCity {
                    ListView1(forecastForCities: forecastForCities,
                             geocodingForNewCity: geocodingForNewCity,
                             isAddCityView: $isAddCityView,
                             isAddCity: $isAddCity)
                } else if newCityGeocodingList.errorFetchForecast == .invalidRequest {
                    ErrorInvalidRequestForAddCityView()
                        .listRowBackground(Color.black)
                }
                Spacer()
            }
        }
        .foregroundColor(Constants.textColor)
    }
    
    private func settingOpener() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}

