import SwiftUI

struct BorderViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color.black.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(5)
            .foregroundColor(Constants.textColor)
    }
}

extension View {
    func bordered() -> some View {
        ModifiedContent(content: self, modifier: BorderViewModifier())
    }
}
