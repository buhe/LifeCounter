//
//  PieChartView.swift
//  Count
//
//  Created by Trae AI on 2/19/25.
//

import SwiftUI

struct PieChartView: View {
    @ObservedObject var model: CountdownModel
    
    // 计算饼图数据
    private var pieData: [PieSlice] {
        let usedDays = min(model.passedDays, model.totalDays)
        let beforeIndependence = min(model.daysBeforeIndependence, usedDays)
        let afterIndependence = max(0, usedDays - model.daysBeforeIndependence)
        let remaining = model.totalDays - usedDays
        
        return [
            PieSlice(value: Double(beforeIndependence), color: .orange, label: "Before Independence"),
            PieSlice(value: Double(afterIndependence), color: .blue, label: "After Independence"),
            PieSlice(value: Double(remaining), color: .gray, label: "Remaining")
        ]
    }
    
    var body: some View {
        VStack {
            Text("Life Cycle")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
                .padding(.bottom, 5)
            
            ZStack {
                ForEach(0..<pieData.count, id: \.self) { index in
                    let cumulative = pieData.prefix(index).reduce(0.0) { $0 + $1.value }
                    let total = pieData.reduce(0.0) { $0 + $1.value }
                    
                    PieSliceView(
                        pieSlice: self.pieData[index],
                        totalValue: total,
                        startAngle: .degrees((cumulative / total) * 360 - 90),
                        endAngle: .degrees(((cumulative + pieData[index].value) / total) * 360 - 90)
                    )
                }
                
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Text("\(model.remainingDays)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 150, height: 150)
            
            // 图例
            HStack(spacing: 20) {
                ForEach(pieData, id: \.label) { slice in
                    HStack(spacing: 5) {
                        Circle()
                            .fill(slice.color)
                            .frame(width: 10, height: 10)
                        Text(slice.label)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

struct PieSlice: Identifiable {
    var id: String { label }
    let value: Double
    let color: Color
    let label: String
}

struct PieSliceView: View {
    let pieSlice: PieSlice
    let totalValue: Double
    let startAngle: Angle
    let endAngle: Angle
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                path.move(to: center)
                path.addArc(center: center,
                           radius: radius,
                           startAngle: startAngle,
                           endAngle: endAngle,
                           clockwise: false)
                path.closeSubpath()
            }
            .fill(pieSlice.color)
        }
    }
}