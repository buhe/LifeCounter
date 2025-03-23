import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), remainingDays: 0, remainingWeeks: 0, backgroundColorOption: "purple")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let model = CountdownModel()
        let colorOption = SharedConfig.sharedUserDefaults?.string(forKey: "backgroundColorOption") ?? "green"
        
        let entry = SimpleEntry(
            date: Date(),
            remainingDays: model.remainingDays,
            remainingWeeks: model.remainingWeeks,
            backgroundColorOption: colorOption
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let model = CountdownModel()
        let colorOption = SharedConfig.sharedUserDefaults?.string(forKey: "backgroundColorOption") ?? "green"
        
        let entry = SimpleEntry(
            date: Date(),
            remainingDays: model.remainingDays,
            remainingWeeks: model.remainingWeeks,
            backgroundColorOption: colorOption
        )
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let remainingDays: Int
    let remainingWeeks: Int
    let backgroundColorOption: String
}

struct CountWidgetEntryView : View {
    var entry: Provider.Entry
    
    func getBackgroundColors(for option: String) -> [Color] {
        switch option {
        case "black":
            return [Color.black, Color(UIColor.darkGray)]
        case "yellow":
            return [.yellow, .orange]
        case "red":
            return [.red, .orange]
        case "green":
            return [.green, .mint]
        default: // purple or any unknown value
            return [.purple, .blue]
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Life")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
            
            HStack(spacing: 15) {
                VStack {
                    Text("\(entry.remainingDays)")
                        .font(.system(size: 18, weight: .bold))
                    Text("Days")
                        .font(.caption)
                }
                
                VStack {
                    Text("\(entry.remainingWeeks)")
                        .font(.system(size: 18, weight: .bold))
                    Text("Weeks")
                        .font(.caption)
                }
            }
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            LinearGradient(gradient: Gradient(colors: getBackgroundColors(for: entry.backgroundColorOption)),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing)
        }
    }
}


struct CountWidget: Widget {
    let kind: String = "CountWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CountWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Life Countdown")
        .description("Display remaining days and weeks.")
        .supportedFamilies([.systemSmall])
    }
}

struct CountWidget_Previews: PreviewProvider {
    static var previews: some View {
        CountWidgetEntryView(entry: SimpleEntry(date: Date(), remainingDays: 10000, remainingWeeks: 1428, backgroundColorOption: "purple"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
