import SwiftUI

struct ForecastForFiveDaysView: View {
    var forecastForCity: ForecastModel.Forecast
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "calendar")
                Text("five-day forecast".uppercased())
            }
            .textBlockHeaderModifier()
            Divider()
            ForEach(forecastForCity.forecastForFiveDays.list, id: \.id) {list in
                HStack {
                    Text(list.dt.getDateStringFromUTC())
                        .frame(width: 45, alignment: .leading)
                    Spacer()
                    if list.maxRain >= 0.11 {
                        switch list.maxRain {
                        case 0.11 ... 0.25:
                            DetailRain(maxRain: list.maxRain, iconName: "d_c2_r1")
                        case 0.25 ... 0.50:
                            DetailRain(maxRain: list.maxRain, iconName: "d_c2_r2")
                        default:
                            DetailRain(maxRain: list.maxRain, iconName: "c3_r3")
                        }
                    } else {
                        Image("01d")
                            .iconsModifier()
                    }
                    Spacer()
                    HStack {
                        Text("\(list.minTemp) \u{00B0}")
                            .opacity(0.7)
                        Rectangle()
                            .fill(LinearGradient(gradient: chartGradientForTemp(list), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 65, height: 5)
                        Text("\(list.maxTemp) \u{00B0}")
                    }
                    .frame(width: 160, alignment: .trailing)
                }
                .font(.body)
                .padding(.bottom, 5)
                .padding(.horizontal, 20)
                Divider()
            }
        }
        .bordered()
    }
    
    func chartGradientForTemp(_ fiveDaysList: ForecastForFiveDaysModel.List) -> Gradient {
        switch fiveDaysList.minTemp {
        case -100...(-20):
            switch fiveDaysList.maxTemp {
            case -100...(-20):
                return Gradient(colors: [Color.blue, Color.blue.opacity(0.7)])
            case -19...0:
                return Gradient(colors: [Color.blue, Color.blue.opacity(0.2)])
            case 1...20:
                return Gradient(colors: [Color.blue, Color.yellow])
            case 21...30:
                return Gradient(colors: [Color.blue, Color.orange])
            default:
                return Gradient(colors: [Color.blue, Color.red])
            }
        case -19...0:
            switch fiveDaysList.maxTemp {
            case -19...0:
                return Gradient(colors: [Color.blue.opacity(0.7), Color.blue.opacity(0.2)])
            case 1...20:
                return Gradient(colors: [Color.blue.opacity(0.7), Color.yellow])
            case 21...30:
                return Gradient(colors: [Color.blue.opacity(0.7), Color.orange])
            default:
                return Gradient(colors: [Color.blue.opacity(0.7), Color.red])
            }
        case 1...20:
            switch fiveDaysList.maxTemp {
            case 1...20:
                return Gradient(colors: [Color.yellow.opacity(0.2), Color.yellow])
            case 21...30:
                return Gradient(colors: [Color.yellow.opacity(0.2), Color.orange])
            default:
                return Gradient(colors: [Color.yellow.opacity(0.2), Color.red])
            }
        case 21...30:
            switch fiveDaysList.maxTemp {
            case 21...30:
                return Gradient(colors: [Color.yellow, Color.orange])
            default:
                return Gradient(colors: [Color.yellow, Color.red])
            }
        default:
            return Gradient(colors: [Color.orange, Color.red])
        }
    }
    
}

struct DetailRain: View {
    var maxRain: Double
    var iconName: String
    
    var body: some View {
        VStack {
            Image(iconName)
                .iconsModifier()
            Text("\(String(format: "%.0f", maxRain * 100)) \u{0025}")
                .font(.caption)
                .opacity(0.7)
        }
    }
}


