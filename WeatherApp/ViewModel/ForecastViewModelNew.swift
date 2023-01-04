import Foundation
import Combine

final class ForecastViewModelNew: ObservableObject {
    //Output
    @MainActor @Published var forecastForCities: Result<Array<ForecastModel.Forecast>, Error>?
    @MainActor @Published var forecastForNewCity: Result<ForecastModel.Forecast, Error>?
    
    private let apiNew: APIProtocol
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    func weatherForecast() {
        apiNew.load(url: "CitiesCoord1")
        
            .flatMap(ForecastModel.fetchWeatherForecasts)
            .asResult()
            .receive(on: DispatchQueue.main)
            .assign(to: &$forecastForCities)
    }
    
    func weatherForecastForNewCity(_ cityCoord: ForecastTodayModel.CityCoord) {
        ForecastModel.fetchWeatherForecast(cityCoord)
            .share()
            .asResult()
            .receive(on: DispatchQueue.main)
            .assign(to: &$forecastForNewCity)
    }
    
    //    func loadCitiesCoord() -> [ForecastTodayModel.CityCoord] {
    //        var citiesCoord: [ForecastTodayModel.CityCoord] = []
    //        if let url = FileManager.documentURL?.appendingPathComponent("CitiesCoord1") {
    //            do {
    //                let data = try Data(contentsOf: url)
    //                let decoder = JSONDecoder()
    //                citiesCoord = try decoder.decode([ForecastTodayModel.CityCoord].self, from: data)
    //            } catch {
    //                citiesCoord = [ForecastTodayModel.CityCoord]()
    //            }
    //        }
    //        return citiesCoord
    //    }
    
    func loadCitiesCoord1() -> [ForecastTodayModel.CityCoord]? {
        var citiesCoord: [ForecastTodayModel.CityCoord] = []
        if let url = FileManager.documentURL?.appendingPathComponent("CitiesCoord1") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                citiesCoord = try decoder.decode([ForecastTodayModel.CityCoord].self, from: data)
            } catch {
                citiesCoord = [ForecastTodayModel.CityCoord]()
            }
        }
        return citiesCoord
    }
    
    
    
    func appendCity(_ forecastForNewCity: ForecastModel.Forecast,
                    _ forecastForCities: [ForecastModel.Forecast]) {
        forecastForCities
            .publisher
            .append(forecastForNewCity)
            .map{$0.forecastToday.coord}
            .collect()
            .sink(receiveValue: {[weak self] citiesCoord in
                self?.save(citiesCoord)
            })
            .store(in: &subscriptions)
    }
    
    func removeCity(_ removeCityModel : ForecastTodayModel,
                    _ forecastForCities: [ForecastModel.Forecast])  {
        forecastForCities
            .publisher
            .filter{$0.forecastToday != removeCityModel}
            .map{$0.forecastToday.coord}
            .collect()
            .sink(receiveValue: {[weak self] citiesCoord in
                
                
                self?.save(citiesCoord)})
            .store(in: &subscriptions)
    }
    
    func save(_ citiesCoord: [ForecastTodayModel.CityCoord])  {
        do {
            let encoder = JSONEncoder()
            let data = try  encoder.encode(citiesCoord)
            if let url = FileManager.documentURL?.appendingPathComponent("CitiesCoord1") {
                try  data.write(to: url)
            }
        }
        catch {
        }
    }
    
    func selectedTab(_ removeCityModel : ForecastTodayModel,
                     _ forecastForCities: [ForecastModel.Forecast]) -> ForecastTodayModel? {
        var forecastToday: ForecastTodayModel?
        
        forecastForCities
            .publisher
            .first(where: {$0.forecastToday != removeCityModel})
            .map{$0.forecastToday}
            .sink(receiveValue: {value in
                forecastToday = value
            })
            .store(in: &subscriptions)
        return forecastToday
    }
    
    @Published var timer = Timer.publish(
        every: Constants.intervalRquestToServer,
        on: .main,
        in: .common)
        .autoconnect()
    
    private var timeIntreval1970 = NSDate().timeIntervalSince1970
    private var tommorow = Date().dayAfterMidnight.timeIntervalSince1970
    
    func isDay(_ forecastTodayForSelectedCity: ForecastTodayModel) -> Bool {
        if Int(NSDate().timeIntervalSince1970) > forecastTodayForSelectedCity.sys.sunrise  && Int(NSDate().timeIntervalSince1970) < forecastTodayForSelectedCity.sys.sunset {
            return true
        } else {
            return false
        }
    }
    
    init(apiNew: APIProtocol) {
        self.apiNew = apiNew
        weatherForecast()
    }
}








