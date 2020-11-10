//
//  MainWidget.swift
//  MainWidget
//
//  Created by Wootae on 10/18/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), homeState: HomeState.create())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), homeState: HomeState.create())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        print("update")
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 1 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, homeState: HomeState.create())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let homeState: HomeState
}

struct MainWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        SmallView(state: entry.homeState)
    }
}

@main
struct MainWidget: Widget {
    let kind: String = "MainWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MainWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MainWidget_Previews: PreviewProvider {
    static var previews: some View {
        MainWidgetEntryView(entry: SimpleEntry(date: Date(), homeState: HomeState.create()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
