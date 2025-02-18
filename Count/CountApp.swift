//
//  CountApp.swift
//  Count
//
//  Created by 顾艳华 on 2/18/25.
//

import SwiftUI

@main
struct CountApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
