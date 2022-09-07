import SwiftUI

extension Image {
    func iconsModifier() -> some View {
        return self
            .resizable()
            .frame(width: 40, height: 30)
    }
}
