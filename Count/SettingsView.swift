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
                DatePicker("出生日期",
                          selection: $model.birthDate,
                          displayedComponents: .date)
                
                Stepper("期望年龄: \(model.expectedAge)",
                        value: $model.expectedAge,
                        in: 1...120)
            }
            .navigationTitle("设置")
            .navigationBarItems(trailing: Button("完成") {
                dismiss()
            })
        }
    }
}
