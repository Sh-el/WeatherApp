import Foundation

struct AirPollutionModel: Codable {
    let list: [List]
}

//MARK: - List
extension AirPollutionModel {
    struct List: Codable {
        let main: Main
        let components: [String: Double]
        let dt: Int
    }
}

//MARK: - Main
extension AirPollutionModel {
    struct Main: Codable {
        let aqi: Int
    }
}







