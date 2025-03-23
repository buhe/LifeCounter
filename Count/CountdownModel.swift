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
        case yellow = "yellow"
        case red = "red"
        
        var colors: [Color] {
            switch self {
            case .purple:
                return [.purple, .blue]
            case .black:
                return [Color.black, Color(UIColor.darkGray)]
            case .yellow:
                return [.yellow, .orange]
            case .red:
                return [.red, .orange]
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
        
        // 读取背景色选项，默认为紫色
        let colorOptionString = SharedConfig.sharedUserDefaults?.string(forKey: "backgroundColorOption") ?? BackgroundColorOption.purple.rawValue
        self.backgroundColorOption = BackgroundColorOption(rawValue: colorOptionString) ?? .purple
        
        // 如果 expectedAge 为 0（未设置），设置默认值
        if self.expectedAge == 0 {
            self.expectedAge = 80
            SharedConfig.sharedUserDefaults?.set(self.expectedAge, forKey: "expectedAge")
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
}
