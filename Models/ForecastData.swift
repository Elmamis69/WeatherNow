import Foundation

struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    struct Main: Codable { let temp: Double}
    struct Weather: Codable { let icon: String}
}

//Modelo simplificado por dia
struct DailyForecast: Identifiable {
    let id = UUID()
    let date : Date
    let avgTempC: Double
    let icon: String
}
