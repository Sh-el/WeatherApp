import SwiftUI

struct ErrorOther: View {
    @EnvironmentObject var model: ForecastViewModel
 
    var body: some View {
        GeometryReader {geo in
            ZStack {
                Image("Clear")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                VStack {
                    Text("Weather information not available.")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    Text("Restart application.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hue: 0.593, saturation: 0.084, brightness: 0.892))
                        .padding(.vertical, 3.0)
                }
                .foregroundColor(Constants.textColor)
            }
        }
    }
}


