//
//  CountWidgetBundle.swift
//  CountWidget
//
//  Created by 顾艳华 on 2/19/25.
//

import WidgetKit
import SwiftUI

@main
struct CountWidgetBundle: WidgetBundle {
    var body: some Widget {
        CountWidget()
        CountWidgetControl()
        CountWidgetLiveActivity()
    }
}
