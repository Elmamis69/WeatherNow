import SwiftUI

struct HomeView: View {
    @StateObject private var vm = WeatherViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.6), .cyan.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack (spacing: 16){
                Text("🌤️ WeatherNow")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    
                TextField("Enter city name", text: $vm.city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                
                Button {
                    Task { await vm.fetchWeather() }
                } label: {
                    Text("Search")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .padding(.bottom, 10)
                if vm.isLoading { ProgressView().tint(.white) }

                if !vm.errorMessage.isEmpty {
                    Text(vm.errorMessage)
                        .font(.callout).bold()
                        .foregroundColor(.white)
                        .padding(8)
                        .background(.red.opacity(0.4))
                        .cornerRadius(8)
                }

                
                VStack(spacing: 10) {
                    Image(systemName: vm.iconName)
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text("\(vm.temperature)°C")
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
