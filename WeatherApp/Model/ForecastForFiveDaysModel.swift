import Foundation

struct ForecastForFiveDaysModel {
    let list: [List]
    
    struct List  {
        var id = UUID()
        let dt: Int
        let minTemp: Int
        let maxTemp: Int
        let maxRain: Double
    }
    
}
