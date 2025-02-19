//
//  CountWidgetLiveActivity.swift
//  CountWidget
//
//  Created by 顾艳华 on 2/19/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CountWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CountWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CountWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CountWidgetAttributes {
    fileprivate static var preview: CountWidgetAttributes {
        CountWidgetAttributes(name: "World")
    }
}

extension CountWidgetAttributes.ContentState {
    fileprivate static var smiley: CountWidgetAttributes.ContentState {
        CountWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CountWidgetAttributes.ContentState {
         CountWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CountWidgetAttributes.preview) {
   CountWidgetLiveActivity()
} contentStates: {
    CountWidgetAttributes.ContentState.smiley
    CountWidgetAttributes.ContentState.starEyes
}
