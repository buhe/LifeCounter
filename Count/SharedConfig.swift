//
//  SharedConfig.swift
//  Count
//
//  Created by Trae AI on 2/19/25.
//

import Foundation
import WidgetKit

class SharedConfig {
    static let groupIdentifier = "group.dev.buhe.Count.widgei"
    
    static var sharedUserDefaults: UserDefaults? {
        UserDefaults(suiteName: groupIdentifier)
    }
}

extension Notification.Name {
    static let countdownDataDidChange = Notification.Name("countdownDataDidChange")
}