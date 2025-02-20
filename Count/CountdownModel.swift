//
//  CountdownModel.swift
//  Count
//
//  Created by 顾艳华 on 2/18/25.
//

import Foundation
import WidgetKit

class CountdownModel: ObservableObject {
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
    
    init() {
        // 从共享的 UserDefaults 读取存储的数据，如果没有则使用默认值
        self.birthDate = SharedConfig.sharedUserDefaults?.object(forKey: "birthDate") as? Date ?? Date()
        self.expectedAge = SharedConfig.sharedUserDefaults?.integer(forKey: "expectedAge") ?? 0
        
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
