# 🌤️ WeatherNow

A clean and modern **iOS weather app** built with **SwiftUI** and the **OpenWeatherMap API**.  
It displays current weather conditions, temperature, humidity, and forecasts in a minimal and elegant interface.  
Designed to practice API integration, JSON parsing, and MVVM architecture in Swift.

---

## 🧭 Overview

WeatherNow allows users to:
- Search for a city and view its current weather.
- See detailed weather information like temperature, humidity, and condition.
- Automatically fetch weather based on current location *(optional phase)*.
- Display a responsive and modern UI with SwiftUI.

---

## ⚙️ Features

- ✅ Built with **SwiftUI** and **MVVM architecture**
- 🌎 **OpenWeatherMap API** integration
- ☁️ Dynamic weather conditions and icons
- 🔁 Real-time updates
- 🧭 Optional location-based weather (Phase 2)
- 🌙 Light/Dark mode support

---

## 🛠️ Requirements

- macOS 13+  
- Xcode 15+  
- iOS 17+  
- Swift 5.9+  
- OpenWeatherMap API key (free)

---

## 🧩 Project Structure

WeatherNow/

├── Models/

│ └── WeatherData.swift

├── ViewModels/

│ └── WeatherViewModel.swift

├── Views/

│ ├── HomeView.swift

│ └── CitySearchView.swift

├── Services/

│ └── WeatherService.swift

└── WeatherNowApp.swift


---

## 🚀 Getting Started

1. Clone this repository  
   ```bash
   git clone https://github.com/tuusuario/WeatherNow.git
      ```
2. Open the project in Xcode
WeatherNow.xcodeproj
3. Get your free API key from OpenWeatherMap
4. Create a file named .env or Config.swift to store your API key safely
let apiKey = "YOUR_API_KEY_HERE"

Build and run the app on the simulator or device

## 🧱Roadmap
- [ ]  Create base SwiftUI project structure
- [ ]  Design main HomeView layout
- [ ]  Implement WeatherService for API calls
- [ ]  Decode JSON response from OpenWeatherMap
- [ ]  Display weather data on screen
- [ ]  Add search by city feature
- [ ]  Handle loading/error states
- [ ]  Add temperature unit conversion (°C/°F)
- [ ]  Implement location-based weather
- [ ]  Add icons and dynamic backgrounds
- [ ]  Polish UI + animations
- [x]  Write README and publish on GitHub

💡 Future Enhancements (Phase 2+)

📍 Location-based weather using CoreLocation

📅 5-day forecast view

📊 Charts for temperature trends

🌩️ Weather alerts and notifications

☁️ Optional iCloud sync for favorites

**Author**

Adrián Félix

Software Engineering

Passionate about iOS development and clean architecture.


GitHub: @Elmamis69

Email: guerofelix234@gmail.com

**License**

This project is licensed under the MIT License.
