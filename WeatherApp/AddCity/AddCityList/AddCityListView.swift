import SwiftUI

struct AddCityListView: View {
    @EnvironmentObject var model: ForecastViewModel
    @StateObject var newCityGeocodingList = GeocodingViewModel()
    
    var forecastForCities: [ForecastModel.Forecast]
    @Binding var selectedTab: ForecastTodayModel?
    @State private var isAddCityView = false
    @Binding var isAddCity: Bool
    
    init(isAddCity: Binding<Bool>,
         forecastForCities: [ForecastModel.Forecast],
         selectedTab: Binding<ForecastTodayModel?>) {
        self._isAddCity = isAddCity
        self.forecastForCities = forecastForCities
        self._selectedTab = selectedTab
    }
    
    //init for AddCityIfCitiesIsEmptyView
    init(isAddCity: Binding<Bool>, forecastForCities: [ForecastModel.Forecast]) {
        self._isAddCity = isAddCity
        self.forecastForCities = forecastForCities
        self._selectedTab = .constant(nil)
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
                
                switch newCityGeocodingList.geocodingForNewCity {
                case .success(let geocodingForNewCity):
                    ListView(forecastForCities: forecastForCities,
                             geocodingForNewCity: geocodingForNewCity,
                             selectedTab: $selectedTab,
                             isAddCityView: $isAddCityView,
                             isAddCity: $isAddCity)
                case .failure(let error):
                    ErrorView(error: error)
                default:
                    LoadingWindowView()
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

