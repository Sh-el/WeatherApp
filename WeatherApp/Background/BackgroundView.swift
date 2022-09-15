import SwiftUI

struct BackgroundView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var forecastTodayForSelectedCity: ForecastTodayModel
    
    var body: some View {
        if model.isDay(forecastTodayForSelectedCity) {
            if let id = forecastTodayForSelectedCity.weather.first?.id {
                switch id {
                case 800:
                    Image("day_clearsky")
                        .bacgroundImagesModifier()
                case 801 ... 802:
                    Image("day_partlycloudy")
                        .bacgroundImagesModifier()
                case 803 ... 804:
                    Image("day_cloudy")
                        .bacgroundImagesModifier()
                case 500 ... 531:
                    Image("day_rain")
                        .bacgroundImagesModifier()
                case 600 ... 622:
                    Image("day_snow")
                        .bacgroundImagesModifier()
                case 701 ... 781:
                    Image("day_fog")
                        .bacgroundImagesModifier()
                default:
                    Image("day_clearsky")
                        .bacgroundImagesModifier()
                }
            }
        }
            else {
                if let id = forecastTodayForSelectedCity.weather.first?.id {
                    switch id {
                    case 800:
                        Image("night_clearsky")
                            .bacgroundImagesModifier()
                    case 801 ... 802:
                        Image("night_partlycloudy")
                            .bacgroundImagesModifier()
                    case 803 ... 804:
                        Image("night_cloudy")
                            .bacgroundImagesModifier()
                    case 500 ... 531:
                        Image("night_rain")
                            .bacgroundImagesModifier()
                    case 600 ... 622:
                        Image("night_snow")
                            .bacgroundImagesModifier()
                    case 701 ... 781:
                        Image("day_fog")
                            .bacgroundImagesModifier()
                    default:
                        Image("night_clearsky")
                            .bacgroundImagesModifier()
                    }
                }
            }
    }
}

extension Image {
    func bacgroundImagesModifier() -> some View {
        return self
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
    }
}

