import SwiftUI

struct ButtonAddCity: View {
    @Binding var isAddCity: Bool
    
    var body: some View {
        HStack {
            Button {
                isAddCity = true
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(Constants.textColor)
                    .padding(5)
                    .padding(.top, 10)
            }
            Spacer()
        }
    }
}

