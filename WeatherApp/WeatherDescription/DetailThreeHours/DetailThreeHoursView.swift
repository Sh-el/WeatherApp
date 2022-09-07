import SwiftUI

struct DetailThreeHoursView: View {
    var list: ForecastForFiveDaysThreeHoursModel.List
    
    var body: some View {
        VStack {
            VStack {
                Text(list.dt.getTimeStringFromUTC())
                Text(list.dt.getDateStringFromUTC())
            }
            .font(.caption)
            switch list.sys.pod {
            case "d":
                if let iconName = list.weather.first?.id {
                    Image("\(iconName)")
                        .iconsModifier()
                }
            default:
                if let iconName = list.weather.first?.id {
                    Image("\(iconName)n")
                        .iconsModifier()
                }
            }
            Text("\(Int((list.main.temp))) \u{2103}")
                .fontWeight(.semibold)
        }
        .foregroundColor(Constants.textColor)
    }
    
}



//struct DescriptionForThreeHours_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailThreeHoursView(index: 1, i: 1)
//            .environmentObject(WeatherViewModel())
//    }
//}
