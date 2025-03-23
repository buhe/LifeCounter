//
//  SettingsView.swift
//  Count
//
//  Created by 顾艳华 on 2/18/25.
//

import SwiftUI
import WidgetKit
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
                    VStack(alignment: .leading) {
                        HStack(spacing: 20) {
                            ForEach(CountdownModel.BackgroundColorOption.allCases, id: \.self) { option in
                                ColorCircleButton(option: option, selectedOption: $model.backgroundColorOption, customColorBinding: Binding(
                                    get: {
                                        let r = CGFloat(SharedConfig.sharedUserDefaults?.float(forKey: "customColorRed") ?? 0.5)
                                        let g = CGFloat(SharedConfig.sharedUserDefaults?.float(forKey: "customColorGreen") ?? 0.5)
                                        let b = CGFloat(SharedConfig.sharedUserDefaults?.float(forKey: "customColorBlue") ?? 0.8)
                                        return Color(red: r, green: g, blue: b)
                                    },
                                    set: { newColor in
                                        let uiColor = UIColor(newColor)
                                        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
                                        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
                                        SharedConfig.sharedUserDefaults?.set(Float(r), forKey: "customColorRed")
                                        SharedConfig.sharedUserDefaults?.set(Float(g), forKey: "customColorGreen")
                                        SharedConfig.sharedUserDefaults?.set(Float(b), forKey: "customColorBlue")
                                        NotificationCenter.default.post(name: .countdownDataDidChange, object: nil)
                                        WidgetCenter.shared.reloadAllTimelines()
                                    }
                                ))
                            }
                        }
                        .padding(.vertical, 10)
                    }
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
    var customColorBinding: Binding<Color>? = nil
    
    var body: some View {
        Group {
            if option == .custom {
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
                        
                        MosaicPattern()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white.opacity(0.7))
                        
                        if selectedOption == option {
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                                .frame(width: 50, height: 50)
                        }
                    }
                    .overlay(
                        ColorPicker("", selection: customColorBinding ?? .constant(.blue))
                            .labelsHidden()
                            .opacity(customColorBinding == nil ? 0 : 1)
                            .onChange(of: customColorBinding?.wrappedValue) { oldValue, newValue in
                                selectedOption = .custom
                            }
                    )
                }
            }
            else {
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
        }
    }
