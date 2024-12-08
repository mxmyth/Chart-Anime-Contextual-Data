//
//  ContentView.swift
//  Chart Anime Contextual+Data
//
//  Created by Mario Tetelepta  on 12/5/24.
//

import SwiftUI

// MARK: - Data Model
struct PieSlice: Identifiable {
    let id = UUID()
    var value: Double
    let color: Color
    let label: String
}

// MARK: - PieChartView
struct PieChartView: View {
    @State private var animate = false

    // Using SwiftData (or a mock data array for demonstration purposes)
    @State private var slices: [PieSlice] = [
        PieSlice(value: 25, color: .red, label: "Red"),
        PieSlice(value: 35, color: .blue, label: "Blue"),
        PieSlice(value: 20, color: .green, label: "Green"),
        PieSlice(value: 10, color: .yellow, label: "Yellow"),
        PieSlice(value: 10, color: .purple, label: "Purple")
    ]

    var total: Double {
        slices.reduce(0) { $0 + $1.value }
    }

    var body: some View {
        VStack {
            // Title
            Text("Interactive Pie Chart")
                .font(.title)
                .padding()

            // Pie Chart
            ZStack {
                ForEach(0..<slices.count, id: \.self) { index in
                    PieSliceView(
                        startAngle: angle(for: index),
                        endAngle: angle(for: index + 1),
                        color: slices[index].color
                    )
                    .scaleEffect(animate ? 1.0 : 0.5) // Animate scale
                    .animation(.easeInOut(duration: 0.8).delay(Double(index) * 0.2), value: animate)
                }
            }
            .frame(width: 300, height: 300)
            
            // Legend
            VStack(alignment: .leading, spacing: 10) {
                ForEach(slices) { slice in
                    HStack {
                        Circle()
                            .fill(slice.color)
                            .frame(width: 15, height: 15)
                        Text("\(slice.label): \(Int(slice.value / total * 100))%")
                    }
                }
            }
            .padding()

            Spacer()

            // Buttons to Modify Data
            HStack {
                // Button to increase the value of the first slice dynamically
                Button(action: {
                    withAnimation {
                        slices[0].value += 5 // Modify data dynamically
                    }
                }) {
                    Text("Add to Red")
                        .padding()
                        .background(Capsule().fill(Color.red))
                        .foregroundColor(.white)
                }

                // Button to decrease the value of the first slice dynamically
                Button(action: {
                    withAnimation {
                        slices[0].value = max(0, slices[0].value - 5) // Ensure value doesn't go below 0
                    }
                }) {
                    Text("Subtract from Red")
                        .padding()
                        .background(Capsule().fill(Color.orange))
                        .foregroundColor(.white)
                }

                // Button to toggle animation
                Button(action: {
                    animate.toggle()
                }) {
                    Text(animate ? "Reset Animation" : "Animate")
                        .padding()
                        .background(Capsule().fill(Color.blue))
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
        .onAppear {
            animate = true
        }
    }

    // Helper to calculate angles
    private func angle(for index: Int) -> Angle {
        let cumulativeValue = slices.prefix(index).reduce(0) { $0 + $1.value }
        return .degrees(cumulativeValue / total * 360)
    }
}

// MARK: - PieSliceView
struct PieSliceView: View {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let center = CGPoint(x: width / 2, y: height / 2)
                let radius = min(width, height) / 2

                path.move(to: center)
                path.addArc(center: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false)
            }
            .fill(color)
        }
    }
}

// MARK: - SwiftData Integration
// Replace the slices array in PieChartView with @Bindable or @ObservedObject if SwiftData is being used.

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView()
    }
}
