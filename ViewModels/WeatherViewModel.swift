import SwiftUI
import Combine
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var city = ""
    @Published var description = ""
    @Published var iconName = "cloud"
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var tempC: Double? = nil
    @Published var background: [Color] = [.blue.opacity(0.6), .cyan.opacity(0.4)]
    @Published var forecast: [DailyForecast] = []

    private let service = WeatherService()
    private let locator = LocationManager()

    // Clima por ciudad
    func fetchWeather() async {
        guard !city.isEmpty else { return }
        await load { [self] in
            let current = try await self.service.fetchWeather(for: self.city)
            let f = try await self.service.fetchForecast(for: self.city)
            self.mapForecast(f)
            return current
        }
    }

    // Clima por ubicación
    func fetchCurrentLocationWeather() async {
        await load { [self] in
            let c = try await self.locator.requestLocation()
            let current = try await self.service.fetchWeather(lat: c.latitude, lon: c.longitude)
            let f = try await self.service.fetchForecast(lat: c.latitude, lon: c.longitude)
            self.mapForecast(f)
            return current
        }
    }

    // MARK: - Infra
    private func load(_ op: @escaping () async throws -> WeatherData) async {
        isLoading = true; errorMessage = ""
        defer { isLoading = false }
        do {
            let data = try await op()
            tempC = data.main.temp
            description = data.weather.first?.description ?? ""
            let code = data.weather.first?.icon ?? ""
            iconName = mapIcon(code)
            setBackground(for: code)
            city = data.name
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Unknown error"
        }
    }

    // MARK: - Mappers
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
        switch code {
        case "01d": background = [.yellow.opacity(0.8), .orange.opacity(0.6)]
        case "01n": background = [.indigo.opacity(0.8), .black.opacity(0.7)]
        case "02d","03d": background = [.blue.opacity(0.6), .teal.opacity(0.5)]
        case "02n","03n": background = [.indigo.opacity(0.7), .blue.opacity(0.5)]
        case "09d","09n","10d","10n": background = [.gray.opacity(0.7), .blue.opacity(0.5)]
        case "11d","11n": background = [.purple.opacity(0.7), .black.opacity(0.7)]
        case "13d","13n": background = [.cyan.opacity(0.7), .mint.opacity(0.6)]
        default: background = [.blue.opacity(0.6), .cyan.opacity(0.4)]
        }
    }

    private func mapForecast(_ resp: ForecastResponse) {
        let cal = Calendar.current
        let groups = Dictionary(grouping: resp.list) { item -> Date in
            cal.startOfDay(for: Date(timeIntervalSince1970: item.dt))
        }
        self.forecast = groups.keys.sorted().prefix(5).map { day in
            let items = groups[day] ?? []
            let avg = items.map { $0.main.temp }.reduce(0, +) / Double(max(items.count, 1))
            let icon = items.map { $0.weather.first?.icon ?? "" }
                .reduce(into: [:]) { $0[$1, default: 0] += 1 }
                .max(by: { $0.value < $1.value })?.key ?? "01d"
            return DailyForecast(date: day, avgTempC: avg, icon: icon)
        }
    }
}
