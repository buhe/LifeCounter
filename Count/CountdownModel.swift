//
//  CountdownModel.swift
//  Count
//
//  Created by 顾艳华 on 2/18/25.
//

import Foundation
import WidgetKit
import SwiftUI

class CountdownModel: ObservableObject {
    enum BackgroundColorOption: String, CaseIterable {
        case purple = "purple"
        case black = "black"
        case red = "red"
        case green = "green"
        case custom = "custom"
        
        var colors: [Color] {
            switch self {
            case .purple:
                return [.purple, .blue]
            case .black:
                return [Color.black, Color(UIColor.darkGray)]
            case .red:
                return [.red, .orange]
            case .green:
                return [.green, .mint]
            case .custom:
                let customColor = Color(UIColor(red: CGFloat(SharedConfig.sharedUserDefaults?.float(forKey: "customColorRed") ?? 0.5),
                                              green: CGFloat(SharedConfig.sharedUserDefaults?.float(forKey: "customColorGreen") ?? 0.5),
                                              blue: CGFloat(SharedConfig.sharedUserDefaults?.float(forKey: "customColorBlue") ?? 0.8),
                                              alpha: 1.0))
                // Use the same color with slight variation for gradient effect
                return [customColor, customColor.opacity(0.7)]
            }
        }
    }
    
    @Published var birthDate: Date {
        didSet {
            SharedConfig.sharedUserDefaults?.set(birthDate, forKey: "birthDate")
            NotificationCenter.default.post(name: .countdownDataDidChange, object: nil)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    @Published var expectedAge: Int {
        didSet {
            SharedConfig.sharedUserDefaults?.set(expectedAge, forKey: "expectedAge")
            NotificationCenter.default.post(name: .countdownDataDidChange, object: nil)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    @Published var independentAge: Int {
        didSet {
            SharedConfig.sharedUserDefaults?.set(independentAge, forKey: "independentAge")
            NotificationCenter.default.post(name: .countdownDataDidChange, object: nil)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    @Published var backgroundColorOption: BackgroundColorOption {
        didSet {
            SharedConfig.sharedUserDefaults?.set(backgroundColorOption.rawValue, forKey: "backgroundColorOption")
            NotificationCenter.default.post(name: .countdownDataDidChange, object: nil)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    init() {
        // 从共享的 UserDefaults 读取存储的数据，如果没有则使用默认值
        self.birthDate = SharedConfig.sharedUserDefaults?.object(forKey: "birthDate") as? Date ?? Date()
        self.expectedAge = SharedConfig.sharedUserDefaults?.integer(forKey: "expectedAge") ?? 0
        self.independentAge = SharedConfig.sharedUserDefaults?.integer(forKey: "independentAge") ?? 0
        
        // 读取背景色选项，默认为绿色
        let colorOptionString = SharedConfig.sharedUserDefaults?.string(forKey: "backgroundColorOption") ?? BackgroundColorOption.green.rawValue
        self.backgroundColorOption = BackgroundColorOption(rawValue: colorOptionString) ?? .green
        
        // 如果 expectedAge 为 0（未设置），设置默认值
        if self.expectedAge == 0 {
            self.expectedAge = 80
            SharedConfig.sharedUserDefaults?.set(self.expectedAge, forKey: "expectedAge")
        }
        
        // 如果 independentAge 为 0（未设置），设置默认值为18岁
        if self.independentAge == 0 {
            self.independentAge = 18
            SharedConfig.sharedUserDefaults?.set(self.independentAge, forKey: "independentAge")
        }
        
        // 添加定时器以定期更新数据
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    var remainingDays: Int {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .year, value: expectedAge, to: birthDate) ?? Date()
        let components = calendar.dateComponents([.day], from: Date(), to: endDate)
        return components.day ?? 0
    }
    
    var remainingWeeks: Int {
        return remainingDays / 7
    }
    
    var remainingAutumns: Int {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .year, value: expectedAge, to: birthDate) ?? Date()
        let components = calendar.dateComponents([.year], from: Date(), to: endDate)
        return components.year ?? 0
    }
    
    // 计算总天数（从出生到预期寿命）
    var totalDays: Int {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .year, value: expectedAge, to: birthDate) ?? Date()
        let components = calendar.dateComponents([.day], from: birthDate, to: endDate)
        return components.day ?? 0
    }
    
    // 计算独立前的天数（从出生到独立年龄）
    var daysBeforeIndependence: Int {
        let calendar = Calendar.current
        let independenceDate = calendar.date(byAdding: .year, value: independentAge, to: birthDate) ?? Date()
        let components = calendar.dateComponents([.day], from: birthDate, to: independenceDate)
        return components.day ?? 0
    }
    
    // 计算已经过去的天数（从出生到现在）
    var passedDays: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: birthDate, to: Date())
        return components.day ?? 0
    }
}
