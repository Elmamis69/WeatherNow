import SwiftUI
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var city = ""
    @Published var description = ""
    @Published var iconName = "cloud"
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var tempC: Double? = nil   // usamos esta para mostrar °C/°F

    private let service = WeatherService()

    func fetchWeather() async {
        guard !city.isEmpty else { return }
        isLoading = true
        errorMessage = ""
        defer { isLoading = false }

        do {
            let data = try await service.fetchWeather(for: city)
            tempC = data.main.temp                      // ← aquí
            description = data.weather.first?.description ?? ""
            iconName = mapIcon(data.weather.first?.icon ?? "")
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Unknown error"
        }
    }

    private func mapIcon(_ code: String) -> String {
        switch code {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d", "10n": return "cloud.rain.fill"
        case "11d", "11n": return "cloud.bolt.rain.fill"
        case "13d", "13n": return "snowflake"
        default: return "cloud.fill"
        }
    }
}
