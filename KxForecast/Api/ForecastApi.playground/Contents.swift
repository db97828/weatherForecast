import UIKit
import CoreLocation


struct Forecast: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ListItem]
    
    struct ListItem: Codable {
        let dt: Int
        
        let main: Main
        struct Main: Codable {
            let temp: Double
        }
        
        let weather: [Weather]
        struct Weather: Codable {
            let description: String
            let icon: String
        }
    }
    
}


enum ApiError: Error {
    case unknown
    case invalidUrl(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}

func fetch<ParsingType: Codable>(urlStr: String, completion: @escaping (Result<ParsingType, Error>) -> ()) {
    guard let url = URL(string: urlStr) else {
        completion(.failure(ApiError.invalidUrl(urlStr)))
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            fatalError(error.localizedDescription)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(ApiError.invalidResponse))
            return
        }
        
        guard httpResponse.statusCode == 200 else {
            completion(.failure(ApiError.failed(httpResponse.statusCode)))
            return
        }
        
        guard let data = data else {
            completion(.failure(ApiError.emptyData))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(ParsingType.self, from: data)
            
            completion(.success(data))
            
        } catch {
//            print(error)
//            fatalError(error.localizedDescription)
            completion(.failure(error))
        }
    }
    task.resume()       // 반드시 resume을 호출해야 실행됨
}

func fetchForecast(cityName: String, completion: @escaping (Result<Forecast, Error>) -> ()) {
    let urlStr = "http://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=93e0788f8e0bd92f4ea11a310a22623a&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
    
}

func fetchForecast(cityId: Int, completion: @escaping (Result<Forecast, Error>) -> ()) {
    let urlStr = "http://api.openweathermap.org/data/2.5/forecast?id=\(cityId)&appid=93e0788f8e0bd92f4ea11a310a22623a&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
    
}

func fetchForecast(location: CLLocation, completion: @escaping (Result<Forecast, Error>) -> ()) {
    let urlStr = "http://api.openweathermap.org/data/2.5/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=93e0788f8e0bd92f4ea11a310a22623a&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
    
}

//fetchForecast(cityName: "seoul") { _ in}
//fetchForecast(cityId: 1835847) { (result) in
//    switch result {
//    case .success(let weather):
//        dump(weather)
//    case .failure(let error):
//        print(error)
//    }
//}

let location = CLLocation(latitude: 37.498206, longitude: 127.02761)
fetchForecast(location: location) { (result) in
        switch result {
        case .success(let weather):
            dump(weather)
        case .failure(let error):
            print(error)
        }
}
