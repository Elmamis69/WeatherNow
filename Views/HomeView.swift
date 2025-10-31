import SwiftUI

struct HomeView: View {
    @State private var city: String = ""
    @State private var temperature: String = "--"
    @State private var description: String = "Loading..."
    @State private var iconName: String = "cloud.sun.fill"
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.6), .cyan.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack (spacing: 16){
                Text("🌤️ WeatherNow")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    
                TextField("Enter city name", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                
                Button(action: {
                }) {
                    Text("Search")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }
                .padding(.bottom, 10)
                
                VStack(spacing: 10) {
                    Image(systemName: iconName)
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text("\(temperature)°C")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(description.capitalized)
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
