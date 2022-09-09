import SwiftUI

struct PressureView: View {
    var forecastTodayForCity: ForecastTodayModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.black.opacity(0.2))
            VStack {
                Image(systemName: "scalemass.fill")
                    .font(.title2)
                Spacer()
                Text("Atmospheric pressure")
                    .font(.body)
                Spacer()
                Text("\(Int(Double(forecastTodayForCity.main.pressure) * 0.75)) mm Hg")
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
        }
    }
}


