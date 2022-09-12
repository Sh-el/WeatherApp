import Foundation
import Combine

extension Publisher {
    func asResult1() -> AnyPublisher<Result<Output, Failure>?, Never> {
        self
            .map(Result.success)
            .catch {error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}

final class ForecastViewModel1: ObservableObject {
    
    @Published var forecastForCities: Result<Array<ForecastModel.Forecast>, Error>? = nil
    @Published var forecastForNewCity: Result<ForecastModel.Forecast, Error>? = nil
    @Published var coordForCities: [ForecastTodayModel.CityCoord]? = nil
    
    
    var subscriptions = Set<AnyCancellable>()
    
    func weatherForecastForCoordinatesOfCities(_ coordForCities: [ForecastTodayModel.CityCoord]?) {
        coordForCities
            .publisher
            .flatMap (ForecastModel.fetchWeatherForecastForCoordinatesOfCities)
            .asResult1()
            .receive(on: DispatchQueue.main)
            .assign(to: &$forecastForCities)
      
    }
    
    func resultForNewCity(_ cityCoord: ForecastTodayModel.CityCoord) {
        forecastForNewCity = nil
        
        ForecastModel.fetchWeatherForecastForCoordinatesOfCity(cityCoord)
            .share()
            .asResult1()
            .receive(on: DispatchQueue.main)
            .assign(to: &$forecastForNewCity)
       
    }
    
    func loadCitiesCoord() -> [ForecastTodayModel.CityCoord] {
        var citiesCoord = [ForecastTodayModel.CityCoord]()
        if let url = FileManager.documentURL?.appendingPathComponent("CitiesCoord1") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                citiesCoord = try decoder.decode([ForecastTodayModel.CityCoord].self, from: data)
                self.coordForCities = citiesCoord
            } catch {
                citiesCoord = [ForecastTodayModel.CityCoord]()
            }
        }
        return citiesCoord
    }
    
    func loadCitiesCoordFuture() -> Future<[ForecastTodayModel.CityCoord], Never> {
        Future {promise in
            promise(.success(self.loadCitiesCoord()))
        }
    }
    
//    func appendCity(_ forecastForNewCity: ForecastModel.Forecast) {
//        forecastForCities?.append(forecastForNewCity)
//        coordForCities?.append(forecastForNewCity.forecastToday.coord)
//    }
//
    func  removeCity(removeCityModel : ForecastTodayModel, forecastForCities: [ForecastModel.Forecast])  {
        forecastForCities
            .publisher
            .filter {$0.forecastToday != removeCityModel}
            .map{$0.forecastToday.coord}
            .collect()
            .sink(receiveValue: {[weak self] citiesCoord in
                self?.saveCitiesCoord(citiesCoord)
            })
            .store(in: &subscriptions)
      
    }
    
    func saveCities(forecastForCities: [ForecastModel.Forecast]) {
        forecastForCities
            .publisher
            .map {$0.forecastToday.coord}
            .collect()
            .sink(receiveValue: {[weak self] value in
                self?.saveCitiesCoord(value)
            })
            .store(in: &subscriptions)
    }
    
    func saveCitiesCoord(_ citiesCoord: [ForecastTodayModel.CityCoord])  {
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
    
    @Published var timer = Timer.publish(
        every: Constants.intervalRquestToServer,
        on: .main,
        in: .common)
        .autoconnect()
    
 
    private var timeIntreval1970 = NSDate().timeIntervalSince1970
    private var tommorow = Date().dayAfterMidnight.timeIntervalSince1970
    
    func isDay(_ forecastTodayForSelectedCity: ForecastTodayModel) -> Bool {
        if Int(NSDate().timeIntervalSince1970) >= forecastTodayForSelectedCity.sys.sunrise  && Int(NSDate().timeIntervalSince1970) < forecastTodayForSelectedCity.sys.sunset {
            return true
        } else {
            return false
        }
    }
    
    init() {
        weatherForecastForCoordinatesOfCities(loadCitiesCoord())
        
    }
    
}

extension Int {
    func getDateStringFromUTC1() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        dateFormatter.locale = Locale(identifier: "us_US")
        return dateFormatter.string(from: date)
    }
}

extension Int {
    func getTimeStringFromUTC1() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "us_US")
        return dateFormatter.string(from: date)
    }
}

extension Int {
    func getTimeIntFromUTC1() -> Int {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.locale = Locale(identifier: "ru_US")
        return Int(dateFormatter.string(from: date)) ?? 0
    }
}

extension FileManager {
    static var documentURL1: URL? {
        return Self.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first
    }
}

extension Date {
    static var midnight1: Date {return Calendar.current.startOfDay(for: Date())}
    var dayAfterMidnight1: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date.midnight)!
    }
}



