import Foundation
import Combine

final class ForecastViewModel: ObservableObject {
    @MainActor @Published var forecastForCities: Result<Array<ForecastModel.Forecast>, Error>?
    @MainActor @Published var forecastForNewCity: Result<ForecastModel.Forecast, Error>?
    
    private var subscriptions = Set<AnyCancellable>()
    
    //    func weatherForecast1(_ coordForCities: @autoclosure () -> [ForecastTodayModel.CityCoord]?) {
    //        coordForCities()
    //            .publisher
    //            .flatMap(ForecastModel.fetchWeatherForecasts)
    //            .asResult()
    //            .receive(on: DispatchQueue.main)
    //            .assign(to: &$forecastForCities)
    //    }
    
    func weatherForecast2() {
        API.load(url: "CitiesCoord1")
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
    
    init() {
        //   weatherForecast1(loadCitiesCoord1())
        weatherForecast2()
    }
}

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>?, Never> {
        self
            .map(Result.success)
            .catch{error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}

extension Int {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        dateFormatter.locale = Locale(identifier: "us_US")
        return dateFormatter.string(from: date)
    }
}

extension Int {
    func getTimeStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "us_US")
        return dateFormatter.string(from: date)
    }
}

extension Int {
    func getTimeIntFromUTC() -> Int {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.locale = Locale(identifier: "ru_US")
        return Int(dateFormatter.string(from: date)) ?? 0
    }
}

extension FileManager {
    static var documentURL: URL? {
        return Self.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first
    }
}

extension Date {
    static var midnight: Date {Calendar.current.startOfDay(for: Date())}
    var dayAfterMidnight: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: Date.midnight)!
    }
}



