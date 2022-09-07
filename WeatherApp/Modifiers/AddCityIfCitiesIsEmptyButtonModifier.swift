import SwiftUI

extension View {
    func addCityIfCitiesIsEmptyButtonModifier() -> some View {
        return self
            .padding()
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .background(.blue.opacity(0.7))
            .cornerRadius(10)
    }
}
