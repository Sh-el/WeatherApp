import SwiftUI

struct LocationAccessDenied: View {
    @Binding var isAddCity: Bool
    
    var body: some View {
        ZStack {
            Image("Clear")
        VStack {
            Text("Access for your location is denied")
            Text("Enter location")
            Button {
                isAddCity = true
            } label: {
                Text("Ok")
                    .addCityIfCitiesIsEmptyButtonModifier()
            }
        }
        .multilineTextAlignment(.center)
        .font(.headline)
        .foregroundColor(Color(hue: 0.593, saturation: 0.084, brightness: 0.892))
        .padding(.vertical, 3.0)
        }
    }
}

