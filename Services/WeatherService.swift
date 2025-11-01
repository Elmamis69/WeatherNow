import Foundation

enum WeatherError: Error, LocalizedError {
    case invalidCity, unauthorized, server
    var errorDescription: String? {
        switch self {
        case .invalidCity: return "City not found."
        case .unauthorized: return "Invalid or missing API key."
        case .server: return "Server error. Try again."
        }
    }
}

struct WeatherService {
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "ffdb6011c6a75dad84caf4658299fa8f"  // <-- pega tu key

    func fetchWeather(for city: String) async throws -> WeatherData {
        let encoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        guard let url = URL(string: "\(baseURL)?q=\(encoded)&appid=\(apiKey)&units=metric") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        let code = (response as? HTTPURLResponse)?.statusCode ?? -1
        if code != 200 {
            if code == 401 { throw WeatherError.unauthorized }
            if code == 404 { throw WeatherError.invalidCity }
            throw WeatherError.server
        }
        return try JSONDecoder().decode(WeatherData.self, from: data)
    }
}
