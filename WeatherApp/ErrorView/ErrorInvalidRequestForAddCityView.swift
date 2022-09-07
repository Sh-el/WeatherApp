import SwiftUI

struct ErrorInvalidRequestForAddCityView: View {
    var body: some View {
        ZStack {
            Color.black
            VStack {
                Image(systemName: "wifi.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                Text("Информация о погоде недоступна")
                    .font(.title)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                VStack {
                    Text("Приложение")
                    Text("не подключено к интернету.")
                    Text("Проверете подключение, затем повторите попытку.")
                }
                .multilineTextAlignment(.center)
                .padding(.vertical, 3.0)
                
                Button("Перейти в настройки") {
                    settingOpener()
                }
                .padding(.vertical, 30.0)
            }
            .opacity(0.9)
            .foregroundColor(Constants.textColor)
        }
    }
    
    private func settingOpener() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

struct ErrorForAddCityView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorInvalidRequestForAddCityView()
    }
}
