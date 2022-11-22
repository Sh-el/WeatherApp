import SwiftUI

struct ForecastForFiveDaysThreeHoursView: View {
    let forecastForCity: ForecastModel.Forecast
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "clock")
                Text("forecast for few hours".uppercased())
            }
            .textBlockHeaderModifier()
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(forecastForCity.forecastForFiveDaysThreeHours.list, id: \.id) {list in
                            DetailThreeHoursView(list: list)
                                .padding(.bottom, 5)
                                .padding(.horizontal, 20)
                        }
                }
            }
            Spacer()
        }
        .bordered()
    }
}


extension View {
    func textBlockHeaderModifier() -> some View {
        return self
            .font(.caption)
            .foregroundColor(Color(hue: 0.593, saturation: 0.084, brightness: 0.892))
            .multilineTextAlignment(.leading)
            .padding(.top, 5.0)
            .padding(.horizontal, 20)
    }
}




