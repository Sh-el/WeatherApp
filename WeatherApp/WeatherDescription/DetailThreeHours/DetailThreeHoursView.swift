import SwiftUI

struct DetailThreeHoursView: View {
    let list: ForecastForFiveDaysThreeHoursModel.List
    
    var body: some View {
        VStack {
            VStack {
                Text(list.dt.getTimeStringFromUTC())
                Text(list.dt.getDateStringFromUTC())
            }
            .font(.caption)
            if let iconName = list.weather.first?.id {
                switch list.sys.pod {
                case "d":
                    Image("\(iconName)")
                        .iconsModifier()
                default:
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


