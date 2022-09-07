import SwiftUI

struct CloudinessView: View {
    var forecastTodayForCity: ForecastTodayModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.black.opacity(0.2))
            VStack {
                Image(systemName: "cloud.fill")
                    .font(.title2)
                Spacer()
                Text("Cloudiness")
                    .font(.body)
                Spacer()
                Text("\(forecastTodayForCity.clouds.all) %")
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
        }
    }
}

//struct CloudinessView_Previews: PreviewProvider {
//    static var previews: some View {
//        CloudinessView(forecastTodayForCity: ForecastTodayModel.empty)
//    }
//}
