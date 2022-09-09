import SwiftUI

struct LoadingWindowView: View {
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
                    Text("Load forecast")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding()
                    LoadingDotView()
                }
                .foregroundColor(Constants.textColor)
            }
        }
        .onAppear {
            Task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    if model.errorFetchForecast == nil {
                        model.errorFetchForecast = .unknownError
                    }
                }
            }
        }
        
    }
}

struct Load_Previews: PreviewProvider {
    static var previews: some View {
        LoadingWindowView()
    }
}
