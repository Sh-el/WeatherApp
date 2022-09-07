import SwiftUI

struct ErrorInvalidRequestForMainView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    @State var timer = Timer.publish(
        every: 5,
        on: .main,
        in: .common)
        .autoconnect()
    
    var body: some View {
        GeometryReader {geo in
            ZStack {
                Image("Clear")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                VStack {
                    Image(systemName: "wifi.slash")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hue: 0.593, saturation: 0.084, brightness: 0.892))
                    Text("Информация о погоде недоступна")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    VStack {
                        Text("Приложение")
                        Text("не подключено к интернету.")
                        Text("Проверете подключение, затем повторите попытку.")
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hue: 0.593, saturation: 0.084, brightness: 0.892))
                    .padding(.vertical, 3.0)
                    
                    Button("Перейти в настройки") {
                        settingOpener()
                    }
                    .padding(.vertical, 30.0)
                }
                .foregroundColor(Constants.textColor)
            }
        }
        .onReceive(timer) { _ in
            model.forecastCities()
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


//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorView()
//            .environmentObject(ForecastViewModel())
//    }
//}
