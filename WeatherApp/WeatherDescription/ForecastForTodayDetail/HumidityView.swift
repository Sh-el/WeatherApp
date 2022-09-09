import SwiftUI

struct HumidityView: View {
    var forecastTodayForCity: ForecastTodayModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.black.opacity(0.2))
            VStack {
                Image(systemName: "humidity.fill")
                    .font(.title2)
                Spacer()
                Text("Humidity")
                    .font(.body)
                Spacer()
                Text("\(forecastTodayForCity.main.humidity) %")
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
        }
    }
}


