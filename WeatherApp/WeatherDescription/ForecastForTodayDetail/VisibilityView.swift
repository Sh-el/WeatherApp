import SwiftUI

struct VisibilityView: View {
    var forecastTodayForCity: ForecastTodayModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.black.opacity(0.2))
            VStack {
                Image(systemName: "binoculars.fill")
                    .font(.title2)
                Spacer()
                Text("Visibility")
                    .font(.body)
                Spacer()
                Text("\(forecastTodayForCity.visibility) m")
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
        }
    }
}


