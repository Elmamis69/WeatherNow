import Fundation

struct WeatherService {
    private let baseURL: "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "YOUR_API_KEY_HERE"
    
    func fetchWeather(for city: String) async throws -> WeatherData {
        guard let url = URL(string: "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(WeatherData.self, from: data)
        return decoded
    }
}
