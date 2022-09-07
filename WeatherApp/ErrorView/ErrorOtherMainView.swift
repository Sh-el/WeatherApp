import SwiftUI

struct ErrorOtherMainView: View {
    @EnvironmentObject var model: ForecastViewModel
    
    @State var timer = Timer.publish(
        every: 30,
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
                    Text("Информация о погоде недоступна")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    Text(model.errorFetchForecast?.errorDescription
                         ?? "Don't know error")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hue: 0.593, saturation: 0.084, brightness: 0.892))
                        .padding(.vertical, 3.0)
                }
                .foregroundColor(Constants.textColor)
            }
        }
        .onReceive(timer) {_ in
            model.forecastCities()
        }
    }
}

struct ErrorAddressUnreachableForMainView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorOtherMainView()
    }
}

