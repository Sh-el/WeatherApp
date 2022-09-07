import SwiftUI

struct AddCityListView: View {
    @EnvironmentObject var model: ForecastViewModel
    @StateObject var newCityGeocodingList = NewCityGeocodingListViewModel()
    @State private var isAddCityView = false
    @Binding var isAddCity: Bool
    @Binding var selectedTab: ForecastTodayModel?
    
    init(isAddCity: Binding<Bool>, selectedTab: Binding<ForecastTodayModel?>) {
        UITableView.appearance().backgroundColor = .clear
        self._isAddCity = isAddCity
        self._selectedTab = selectedTab
    }
    
    init(isAddCity: Binding<Bool>) {
        UITableView.appearance().backgroundColor = .clear
        self._isAddCity = isAddCity
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
                if let geocodingForNewCity = newCityGeocodingList.geocodingForNewCity {
                    List(geocodingForNewCity, id: \.id) {geocodingForNewCity in
                        Button {
                            let coord = ForecastTodayModel.CityCoord(
                                lat: geocodingForNewCity.lat,
                                lon: geocodingForNewCity.lon)
                            model.forecastNewCity(coord)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                isAddCityView = true
                            }
                        } label: {
                            HStack {
                                Text(geocodingForNewCity.name)
                                    .fontWeight(.thin)
                                Text(geocodingForNewCity.country)
                                    .fontWeight(.thin)
                                Text(geocodingForNewCity.state ?? "")
                                    .fontWeight(.thin)
                            }
                            .font(.headline)
                            .opacity(0.9)
                            .lineLimit(1)
                        }
                        .sheet(isPresented: $isAddCityView) {
                            AddCityView(isAddCityView: $isAddCityView, isAddCity: $isAddCity, selectedTab: $selectedTab)
                        }
                        .listRowBackground(Color.black)
                    }
                }
                else if newCityGeocodingList.errorFetchForecast == .invalidRequest {
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

//struct CityAddView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        AddCityView()
//            .environmentObject(WeatherViewModel())
//    }
//}
