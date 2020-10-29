//
//  Widget.swift
//  Widget
//
//  Created by Wootae on 10/3/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct MapEntry: TimelineEntry {
    var date: Date
    var status: UserStatus = UserStatus(latitude: 0, longitude: 0, distance: 0, tracking: false)
}

struct UserStatus {
    var latitude: Double
    var longitude: Double
    var distance: Double
    var tracking: Bool
}

@available(iOS 14.0, *)
struct MapProvider: TimelineProvider {
 
    func getSnapshot(in context: Context, completion: @escaping (MapEntry) -> Void) {
        let date = Date()
        let entry: MapEntry
        entry = MapEntry(date: date)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MapEntry>) -> Void) {
            // Create a timeline entry for "now."
        let date = Date()
        let entry: MapEntry
        entry = MapEntry(date: date)
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: date)!
        let timeline = Timeline(entries:[entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
    
    func placeholder(in context: Context) -> MapEntry {
        MapEntry(date: Date())
    }
}

@available(iOS 14.0, *)
struct MainView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var userStatus: UserStatus
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: WidgetView()
        case .systemMedium: WidgetView()
        case .systemLarge: WidgetView()
        default: WidgetView()
        }
    }
}

@available(iOS 14.0, *)
struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
