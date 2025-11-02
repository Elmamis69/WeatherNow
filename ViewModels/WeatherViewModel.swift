import SwiftUI
import Combine
internal import _LocationEssentials

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var city = ""
    @Published var description = ""
    @Published var iconName = "cloud"
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var tempC: Double? = nil
    @Published var background: [Color] = [.blue.opacity(0.6), .cyan.opacity(0.4)] // NUEVO

    private let service = WeatherService()
    private let locator = LocationManager() // si ya lo tienes

    func fetchWeather() async {
        guard !city.isEmpty else { return }
        await load { try await self.service.fetchWeather(for: self.city) }
    }

    func fetchCurrentLocationWeather() async {
        await load {
            let c = try await self.locator.requestLocation()
            return try await self.service.fetchWeather(lat: c.latitude, lon: c.longitude)
        }
    }

    // MARK: - Private
    private func load(_ op: @escaping () async throws -> WeatherData) async {
        isLoading = true; errorMessage = ""
        defer { isLoading = false }
        do {
            let data = try await op()
            tempC = data.main.temp
            description = data.weather.first?.description ?? ""
            let code = data.weather.first?.icon ?? ""
            iconName = mapIcon(code)
            setBackground(for: code)                 // ← NUEVO
            city = data.name
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Unknown error"
        }
    }

    private func mapIcon(_ code: String) -> String {
        switch code {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d","02n": return "cloud.sun.fill"
        case "03d","03n": return "cloud.fill"
        case "09d","09n": return "cloud.drizzle.fill"
        case "10d","10n": return "cloud.rain.fill"
        case "11d","11n": return "cloud.bolt.rain.fill"
        case "13d","13n": return "snowflake"
        default: return "cloud.fill"
        }
    }

    private func setBackground(for code: String) {
        // Gradientes suaves por estado
        switch code {
        case "01d": background = [.yellow.opacity(0.8), .orange.opacity(0.6)]         // despejado día
        case "01n": background = [.indigo.opacity(0.8), .black.opacity(0.7)]          // despejado noche
        case "02d","03d": background = [.blue.opacity(0.6), .teal.opacity(0.5)]       // nubes día
        case "02n","03n": background = [.indigo.opacity(0.7), .blue.opacity(0.5)]     // nubes noche
        case "09d","09n","10d","10n": background = [.gray.opacity(0.7), .blue.opacity(0.5)] // lluvia
        case "11d","11n": background = [.purple.opacity(0.7), .black.opacity(0.7)]    // tormenta
        case "13d","13n": background = [.cyan.opacity(0.7), .mint.opacity(0.6)]       // nieve
        default: background = [.blue.opacity(0.6), .cyan.opacity(0.4)]
        }
    }
}
