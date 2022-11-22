import SwiftUI
import MapKit

struct WeatherDescriptionView: View {
    let forecastForCity: ForecastModel.Forecast
    
    var body: some View {
        GeometryReader{geo in
            VStack {
                ForecastTodayView(forecastTodayForCity: forecastForCity.forecastToday)
                ScrollView(showsIndicators: false) {
                    ForecastForFiveDaysThreeHoursView(forecastForCity: forecastForCity)
                    ForecastForFiveDaysView(forecastForCity: forecastForCity)
                    AirPollutionView(forecastForCity: forecastForCity)
                    ForecastForTodayDetailsView(forecastForCity: forecastForCity)
//                    MapView(
//                        mapRegion: MKCoordinateRegion(
//                            center: CLLocationCoordinate2D(
//                                latitude: forecastForCity.forecastToday.coord.lat,
//                                longitude: forecastForCity.forecastToday.coord.lon),
//                            span: MKCoordinateSpan(
//                                latitudeDelta: 0.2,
//                                longitudeDelta: 0.2)),
//                        geo: geo)
                }
            }
        }
    }
}





