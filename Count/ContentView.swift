import SwiftUI

struct ContentView: View {
    @StateObject private var model = CountdownModel()
    @State private var isSettingsPresented = false
    
    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(gradient: Gradient(colors: model.backgroundColorOption.colors),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("Life Countdown")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                
                CountdownCard(title: "Remaining Days", value: model.remainingDays)
                CountdownCard(title: "Remaining Weeks", value: model.remainingWeeks)
                CountdownCard(title: "Remaining Years", value: model.remainingAutumns)
                
                // 添加饼图视图
                PieChartView(model: model)
            }
            .padding()
            
            // Settings button in top-right corner
            VStack {
                HStack {
                    Spacer()
                    Button(action: { isSettingsPresented = true }) {
                        Image(systemName: "gear")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .padding([.top, .trailing], 16)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsView(model: model)
        }
    }
}

struct CountdownCard: View {
    let title: String
    let value: Int
    @State private var animate = false
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
            
            Text("\(value)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .scaleEffect(animate ? 1.1 : 1.0)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5).repeatForever(autoreverses: true),
                          value: animate)
                .onAppear {
                    animate = true
                }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}
