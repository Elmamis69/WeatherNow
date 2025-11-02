import SwiftUI

struct HomeView: View {
    @StateObject private var vm = WeatherViewModel()
    @AppStorage("useCelsius") private var useCelsius = true

    // Temperatura formateada según unidad
    private var valueText: String {
        guard let c = vm.tempC else { return "--" }
        let v = useCelsius ? c : (c * 9/5 + 32)
        return String(format: "%.0f", v)
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.6), .cyan.opacity(0.4)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("🌤️ WeatherNow")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                    .padding(.top, 60)

                TextField("Enter city name", text: $vm.city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)

                Picker("Units", selection: $useCelsius) {
                    Text("°C").tag(true)
                    Text("°F").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Button {
                    Task { await vm.fetchWeather() }
                } label: {
                    Text(vm.isLoading ? "Searching..." : "Search")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .disabled(vm.isLoading)
                .padding(.bottom, 10)

                if vm.isLoading { ProgressView().tint(.white) }

                if !vm.errorMessage.isEmpty {
                    Text(vm.errorMessage)
                        .font(.callout).bold()
                        .foregroundColor(.white)
                        .padding(8)
                        .background(.red.opacity(0.45))
                        .cornerRadius(10)
                }
                
                Button {
                    Task { await vm.fetchCurrentLocationWeather()}
                } label : {
                    Text("Use my location")
                        .font(.subheadline).bold()
                        .padding(.horizontal, 24).padding(.vertical, 8)
                        .background(.ultraThinMaterial).cornerRadius(10)
                }
                .disabled(vm.isLoading)
                
                // Bloque de datos
                VStack(spacing: 10) {
                    Image(systemName: vm.iconName)
                        .font(.system(size: 80))
                        .foregroundColor(.white)

                    Text("\(valueText)°\(useCelsius ? "C" : "F")")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundColor(.white)

                    Text(vm.description.capitalized)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
