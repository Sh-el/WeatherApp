import SwiftUI

struct DotView: View {
    @State var delay: Double = 0
    @State private var scale: CGFloat = 0.5
    @State private var sizeDot: CGFloat = 40
    var body: some View {
        Image(systemName: "sun.max.fill")
            .resizable()
            .foregroundColor(.yellow)
            .frame(width: sizeDot, height: sizeDot)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6).repeatForever().delay(delay)) {
                    scale = 1
                }
            }
    }
}

struct LoadingDotView: View {
    var body: some View {
        HStack{
        DotView()
        DotView(delay: 0.2)
        DotView(delay: 0.4)
        }
    
    }
}

