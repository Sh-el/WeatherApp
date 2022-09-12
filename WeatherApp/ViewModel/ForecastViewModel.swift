import Foundation
import Combine

final class ForecastViewModel: ObservableObject {
    
    @Published var forecastForCities: [ForecastModel.Forecast]? = nil
    @Published var forecastForNewCity: ForecastModel.Forecast? = nil
    @Published var coordForCities: [ForecastTodayModel.CityCoord]? = nil
    
    @Published var errorFetchForecast: API.RequestError? = nil
    
    var subscriptions = Set<AnyCancellable>()
    
    func forecastCities() {
        coordForCities = loadCitiesCoord()
        let publisher = coordForCities
            .publisher
            .flatMap (ForecastModel.fetchWeatherForecastForCoordinatesOfCities)
            .share()
        
        publisher
            .asResult()
            .map {result in
                switch result {
                case .failure:
                    return nil
                case .success(let weather):
                    return weather
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$forecastForCities)
        
        publisher
            .asResult()
            .errorFetchForecastForCities()
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorFetchForecast)
    }
    
    func forecastNewCity(_ cityCoord: ForecastTodayModel.CityCoord) {
        forecastForNewCity = nil
        
        let publisher = ForecastModel.fetchWeatherForecastForCoordinatesOfCity(cityCoord)
            .share()
        
        publisher
            .asResult()
            .map {result in
                switch result {
                case .failure:
                    return nil
                case .success(let weather):
                    return weather
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$forecastForNewCity)
        
        publisher
            .asResult()
            .errorFetchForecastForCity()
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorFetchForecast)
    }
    
    func loadCitiesCoord() -> [ForecastTodayModel.CityCoord] {
        var citiesCoord = [ForecastTodayModel.CityCoord]()
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
    
    func loadCitiesCoordFuture() -> Future<[ForecastTodayModel.CityCoord], Never> {
        Future {promise in
            promise(.success(self.loadCitiesCoord()))
        }
    }
    
    func appendCity(_ forecastForNewCity: ForecastModel.Forecast) {
        forecastForCities?.append(forecastForNewCity)
        coordForCities?.append(forecastForNewCity.forecastToday.coord)
    }
    
    func  removeCity(_ forecastModel: ForecastTodayModel)  {
        forecastForCities?.remove(
            at: forecastForCities?.firstIndex(
                where: {$0.forecastToday == forecastModel}) ?? 0
        )
        coordForCities?.remove(
            at: coordForCities?.firstIndex(
                where: {$0 == forecastModel.coord}) ?? 0
        )
    }
    
    func saveCities() {
        forecastForCities?
            .publisher
            .map {
                ForecastTodayModel.CityCoord(
                    lat: $0.forecastToday.coord.lat,
                    lon: $0.forecastToday.coord.lon)
            }
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
    
    //  private var hours = Calendar.current.component(.hour, from: Date())
    //  private var minutes = Calendar.current.component(.minute, from: Date())
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
        forecastCities()
        
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
    static var midnight: Date {return Calendar.current.startOfDay(for: Date())}
    var dayAfterMidnight: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date.midnight)!
    }
}

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self
            .map(Result.success)
            .catch {error in
                Just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == Result<Array<ForecastModel.Forecast>, Error>, Failure == Never {
    func errorFetchForecastForCities() -> AnyPublisher<API.RequestError?, Never> {
        self
            .map {result  in
                switch result {
                case .failure(let error):
                    if case API.RequestError.addressUnreachable = error  {
                        return API.RequestError.addressUnreachable}
                    else if case API.RequestError.invalidRequest = error  {
                        return API.RequestError.invalidRequest}
                    else if case API.RequestError.decodingError = error  {
                        return API.RequestError.decodingError}
                    else {return API.RequestError.decodingError}
                case .success:
                    return API.RequestError.noError
                }
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == Result<ForecastModel.Forecast, Error>, Failure == Never {
    func errorFetchForecastForCity() -> AnyPublisher<API.RequestError?, Never> {
        self
            .map {result  in
                switch result {
                case .failure(let error):
                    if case API.RequestError.addressUnreachable = error  {
                        return API.RequestError.addressUnreachable}
                    else if case API.RequestError.invalidRequest = error  {
                        return API.RequestError.invalidRequest}
                    else if case API.RequestError.decodingError = error  {
                        return API.RequestError.decodingError}
                    else {return API.RequestError.decodingError}
                case .success:
                    return API.RequestError.noError
                }
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == Result<Array<GeocodingModel.Geocoding>, Error>, Failure == Never {
    func errorFetchGeocodingForCities() -> AnyPublisher<API.RequestError?, Never> {
        self
            .map {result  in
                switch result {
                case .failure(let error):
                    if case API.RequestError.addressUnreachable = error  {
                        return API.RequestError.addressUnreachable}
                    else if case API.RequestError.invalidRequest = error  {
                        return API.RequestError.invalidRequest}
                    else if case API.RequestError.decodingError = error  {
                        return API.RequestError.decodingError}
                    else {return API.RequestError.decodingError}
                case .success:
                    return API.RequestError.noError
                }
            }
            .eraseToAnyPublisher()
    }
}
