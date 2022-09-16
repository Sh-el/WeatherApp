import SwiftUI

struct InvalidRequest: View {
    @EnvironmentObject var model: ForecastViewModel
    
    var color: Color
    
    @State var timer = Timer.publish(
        every: 5,
        on: .main,
        in: .common)
        .autoconnect()
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .foregroundColor(Color(hue: 0.593, saturation: 0.084, brightness: 0.892))
            Text("Weather information not available.")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            VStack {
                Text("Application")
                Text("not connected to the internet.")
                Text("Check your connection, then try againу.")
            }
            .multilineTextAlignment(.center)
            .foregroundColor(Color(hue: 0.593, saturation: 0.084, brightness: 0.892))
            .padding(.vertical, 3.0)
            
            Button("Go to settings") {
                settingOpener()
            }
            .padding(.vertical, 30.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Constants.textColor)
        .background(color)
        .onReceive(timer) {_ in
            model.weatherForecastForCoordinatesOfCities(model.loadCitiesCoord())
        }
    }
    
    private func settingOpener() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}


