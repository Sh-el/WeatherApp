import SwiftUI

struct ButtonRemoveCity: View {
    @Binding var isRemoveCity: Bool
    
    var body: some View {
        HStack {
            Button {
                isRemoveCity = true
            } label: {
                Image(systemName: "minus")
                    .font(.title)
                    .foregroundColor(Constants.textColor)
                    .padding(5)
                    .padding(.top, 20)
            }
            Spacer()
        }
    }
}

