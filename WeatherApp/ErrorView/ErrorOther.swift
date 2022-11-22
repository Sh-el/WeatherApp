import SwiftUI

struct ErrorOther: View {
    let color: Color
 
    var body: some View {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(Constants.textColor)
                .background(color)
    }
}


