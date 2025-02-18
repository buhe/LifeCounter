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
                DatePicker("Birth Date",
                          selection: $model.birthDate,
                          displayedComponents: .date)
                
                Stepper("Expected Age: \(model.expectedAge)",
                        value: $model.expectedAge,
                        in: 1...120)
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}
