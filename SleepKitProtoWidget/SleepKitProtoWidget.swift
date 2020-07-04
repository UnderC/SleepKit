//
//  SleepKitProtoWidget.swift
//  SleepKitProtoWidget
//
//  Created by 현 on 2020/06/30.
//  Copyright © 2020 현. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), percent: 0, configuration: configuration)
        completion(entry)
    }

    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let sleep = SleepKitStruct()
        let date = Date()
        let entry = SimpleEntry(date: date, percent: sleep.percent, configuration: configuration)
        
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 10, to: date)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let percent: Float
    public let configuration: ConfigurationIntent
}

struct SleepKitProtoWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        return ProgressView(progress: entry.percent)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct PlaceholderView : View {
    var body: some View {
        ProgressView(progress: 0)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

@main
struct SleepKitProtoWidget: Widget {
    private let kind: String = "SleepKitProtoWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
            SleepKitProtoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("SleepKit")
        .description("당신의 숙면 시간을 아주 잘 보여드리는 그러한 위젯이옵니다.")
    }
}

struct SleepKitProtoWidget_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
