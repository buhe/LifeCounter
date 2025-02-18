//
//  CountdownModel.swift
//  Count
//
//  Created by 顾艳华 on 2/18/25.
//

import Foundation

class CountdownModel: ObservableObject {
    @Published var birthDate: Date {
        didSet {
            UserDefaults.standard.set(birthDate, forKey: "birthDate")
        }
    }
    
    @Published var expectedAge: Int {
        didSet {
            UserDefaults.standard.set(expectedAge, forKey: "expectedAge")
        }
    }
    
    init() {
        // 从 UserDefaults 读取存储的数据，如果没有则使用默认值
        self.birthDate = UserDefaults.standard.object(forKey: "birthDate") as? Date ?? Date()
        self.expectedAge = UserDefaults.standard.integer(forKey: "expectedAge")
        
        // 如果 expectedAge 为 0（未设置），设置默认值
        if self.expectedAge == 0 {
            self.expectedAge = 80
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
