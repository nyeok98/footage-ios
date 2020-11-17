//
//  MainWidget.swift
//  MainWidget
//
//  Created by Wootae on 10/18/20.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import WidgetKit
import SwiftUI

struct IntentProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        return WidgetEntry(date: Date(), selectedColor: "#EADE4Cff")
    }
    
    func getSnapshot(for configuration: SelectColorIntent, in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        guard let hex = configuration.color?.identifier else { return }
        let entry = WidgetEntry(date: Date(), selectedColor: hex)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectColorIntent, in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        guard let hex = configuration.color?.identifier else { return }
        let entry = WidgetEntry(date: Date(), selectedColor: hex)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let selectedColor: String
}

struct MainWidgetEntryView : View {
    var entry: IntentProvider.Entry
    var body: some View {
        SmallView(entry: entry)
    }
}

@main
struct MainWidget: Widget {
    let kind: String = "MainWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: "co.el.footage.MainWidget",
            intent: SelectColorIntent.self,
            provider: IntentProvider()
            ) { entry in
            SmallView(entry: entry)
        }
        .configurationDisplayName("발자취 위젯")
        .description("위젯을 추가해 홈 화면에서 기록을 시작하세요")
    }
}
