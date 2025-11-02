import SwiftUI

struct HomeView: View {
    @StateObject private var vm = WeatherViewModel()
    @AppStorage("useCelsius") private var useCelsius = true

    private var valueText: String {
        guard let c = vm.tempC else { return "--" }
        let v = useCelsius ? c : (c * 9/5 + 32)
        return String(format: "%.0f", v)
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: vm.background,
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.6), value: vm.background)

            ScrollView {
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
                        .submitLabel(.search)
                        .onSubmit { Task { await vm.fetchWeather() } }
                        .overlay(alignment: .trailing) {
                            if !vm.city.isEmpty {
                                Button(action: { vm.city = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.trailing, 16)
                            }
                        }

                    Picker("Units", selection: $useCelsius) {
                        Text("°C").tag(true)
                        Text("°F").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    HStack(spacing: 12) {
                        Button {
                            Task { await vm.fetchWeather() }
                        } label: {
                            Text(vm.isLoading ? "Searching..." : "Search")
                                .fontWeight(.semibold)
                                .padding(.horizontal, 24).padding(.vertical, 10)
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                        }
                        .disabled(vm.isLoading)

                        Button {
                            Task { await vm.fetchCurrentLocationWeather() }
                        } label: {
                            Text("Use my location")
                                .font(.subheadline).bold()
                                .padding(.horizontal, 16).padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }
                        .disabled(vm.isLoading)
                    }

                    if vm.isLoading { ProgressView().tint(.white) }

                    if !vm.errorMessage.isEmpty {
                        Text(vm.errorMessage)
                            .font(.callout).bold()
                            .foregroundColor(.white)
                            .padding(8)
                            .background(.red.opacity(0.45))
                            .cornerRadius(10)
                    }

                    VStack(spacing: 10) {
                        Image(systemName: vm.iconName)
                            .font(.system(size: 84, weight: .regular))
                            .symbolEffect(.bounce, value: vm.iconName)

                        Text("\(valueText)°\(useCelsius ? "C" : "F")")
                            .font(.system(size: 64, weight: .semibold))
                            .contentTransition(.numericText())

                        Text(vm.description.capitalized)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 24)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: .black.opacity(0.15), radius: 12, y: 6)

                    Spacer(minLength: 24)
                }
                .padding()
            }
            .refreshable {
                if !vm.city.isEmpty { await vm.fetchWeather() }
            }
        }
        .onTapGesture { UIApplication.shared.hideKeyboard() }
    }
}

#Preview { HomeView() }
