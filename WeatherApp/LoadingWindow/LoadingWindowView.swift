import SwiftUI

struct LoadingWindowView: View {
    @EnvironmentObject var model: ForecastViewModel
    var color: Color
    
    var body: some View {
        VStack {
            Text("Loading")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding()
            LoadingDotView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
        .foregroundColor(Constants.textColor)
        .onAppear {
            Task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    if model.forecastForCities == nil {
                        model.forecastForCities = .failure(API.RequestError.unknownError)
                    }
                }
            }
        }
        
    }
}


