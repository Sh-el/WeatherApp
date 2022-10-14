import SwiftUI

struct ForecastTodayView: View {
    var forecastTodayForCity: ForecastTodayModel
    
    var body: some View {
        VStack {
            Text(forecastTodayForCity.name)
                .font(.title)
                .fontWeight(.regular)
                .lineLimit(2)
                .frame(width: 200)
                .padding(.top, 10)
//            Text("\(forecastTodayForCity.coord.lat)")
            Text("\(String(Int(forecastTodayForCity.main.temp))) \u{2103}")
                .font(.system(size: 60.0))
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
            Text(forecastTodayForCity.weather[0].weatherDescription.capitalized)
                .padding(.bottom, 5)
            HStack {
                HStack{
                    Image(systemName: "sunrise.fill")
                        .foregroundColor(.yellow)
                    Text("\(forecastTodayForCity.sys.sunrise.getTimeStringFromUTC())")
                        .fontWeight(.thin)
                }
                .font(.footnote)
                .padding(.leading, 20)
                Spacer()
                HStack {
                    Image(systemName: "wind")
                    Text("\(String(forecastTodayForCity.wind.speed)) m/s")
                }
                Spacer()
                HStack {
                    Text("\(forecastTodayForCity.sys.sunset.getTimeStringFromUTC())")
                        .fontWeight(.thin)
                    Image(systemName: "sunset.fill")
                        .foregroundColor(.orange)
                }
                .font(.footnote)
                .padding(.trailing, 20)
            }
        }
        .foregroundColor(Constants.textColor)
        .lineLimit(/*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
}


