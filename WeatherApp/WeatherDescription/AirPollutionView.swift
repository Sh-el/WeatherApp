import SwiftUI

struct AirPollutionView: View {
    let forecastForCity: ForecastModel.Forecast
    
    var body: some View {
        if !forecastForCity.airPollutionModel.list.isEmpty,
           let aqi = forecastForCity.airPollutionModel.list.first?.main.aqi {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "wind")
                    Text("air pollution".uppercased())
                }
                .textBlockHeaderModifier()
                Divider()
                VStack {
                    HStack {
                        Text("Air Quality Index")
                        Text("\(aqi) -")
                        Text(qualitativeName(aqi: aqi))
                    }
                    .font(.title2)
                    .padding(.bottom, 5)
                    Rectangle()
                        .fill(LinearGradient(gradient: chartGradientForAqi(aqi: aqi), startPoint: .leading, endPoint: .trailing))
                        .frame(width: 200, height: 5)
                    HStack {
                        Text("Pollutant concentration in μg/m3:")
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        Spacer()
                    }
                    if let components = forecastForCity.airPollutionModel.list.first?.components {
                        ForEach(components.sorted(by: >), id: \.key) {key, value in
                            HStack {
                                Text(descriptionComponents(key))
                                Spacer()
                                Text(String(format: "%.2f", value))
                            }
                            .font(.footnote)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .bordered()
        }
    }
    
    func descriptionComponents(_ components: String) -> String {
        switch components {
        case "co":
            return "CO (Carbon monoxide)"
        case "no":
            return "NO (Nitrogen monoxide)"
        case "no2":
            return "NO2 (Nitrogen dioxide)"
        case "o3":
            return "O3 (Ozone)"
        case "so2":
            return "SO2 (Sulphur dioxide)"
        case "pm2_5":
            return "PM2.5 (Fine particles matter)"
        case "pm10":
            return "PM10 (Coarse particulate matter)"
        default:
            return  "NH3 (Ammonia)"
        }
    }
    
    func qualitativeName(aqi: Int) -> String {
        switch aqi {
        case 1:
            return "Good"
        case 2:
            return "Fair"
        case 3:
            return "Moderate"
        case 4:
            return "Poor"
        default:
            return "Very Poor"
        }
    }
    
    func chartGradientForAqi(aqi: Int) -> Gradient {
        switch aqi {
        case 1:
            return Gradient(colors: [Color.green, Color.green.opacity(0.7)])
        case 2:
            return Gradient(colors: [Color.blue.opacity(0.7), Color.blue.opacity(0.2)])
        case 3:
            return Gradient(colors: [Color.yellow.opacity(0.7), Color.yellow.opacity(0.2)])
        case 4:
            return Gradient(colors: [Color.orange.opacity(0.7), Color.orange.opacity(0.2)])
        default:
            return Gradient(colors: [Color.red.opacity(0.7), Color.red.opacity(0.2)])
        }
    }
    
}



