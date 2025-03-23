//
//  SettingsView.swift
//  Count
//
//  Created by 顾艳华 on 2/18/25.
//

import SwiftUI
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model: CountdownModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Settings")) {
                    DatePicker("Birth Date",
                              selection: $model.birthDate,
                              displayedComponents: .date)
                    
                    Stepper("Expected Age: \(model.expectedAge)",
                            value: $model.expectedAge,
                            in: 1...120)
                    
                    Stepper("Independence Age: \(model.independentAge)",
                            value: $model.independentAge,
                            in: 1...model.expectedAge)
                }
                
                Section(header: Text("Background Color")) {
                    HStack(spacing: 20) {
                        ForEach(CountdownModel.BackgroundColorOption.allCases, id: \.self) { option in
                            ColorCircleButton(option: option, selectedOption: $model.backgroundColorOption)
                        }
                    }
                    .padding(.vertical, 10)
                    .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

struct ColorCircleButton: View {
    let option: CountdownModel.BackgroundColorOption
    @Binding var selectedOption: CountdownModel.BackgroundColorOption
    
    var body: some View {
        Button(action: {
            selectedOption = option
        }) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: option.colors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                    .frame(width: 50, height: 50)
                    .shadow(radius: 3)
                
                if selectedOption == option {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 50, height: 50)
                }
            }
            .contentShape(Rectangle()) // 扩展点击区域
        }
        .buttonStyle(PlainButtonStyle()) // 移除按钮默认样式
    }
}
