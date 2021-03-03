//
//  Forecast.swift
//  KxForecast
//
//  Created by dabeen on 2021/03/02.
//

import Foundation

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

struct ForecastData {
    let date: Date
    let icon: String
    let weather: String
    let temperature: Double
}
