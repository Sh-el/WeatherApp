import SwiftUI

struct LoadingWindowView: View {
    @EnvironmentObject var model: ForecastViewModel
    let color: Color
    
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
    }
}


