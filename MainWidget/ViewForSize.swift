//
//  ViewForSize.swift
//  footage
//
//  Created by Wootae on 10/11/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import SwiftUI

struct SmallView: View {
    let state: HomeState
    let isTracking = UserDefaults(suiteName: "group.footage")!.bool(forKey: "isTracking")
    let distanceToday = UserDefaults(suiteName: "group.footage")!.double(forKey: "isTracking")
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10) {
            Text(String(distanceToday))
            Text(String(isTracking ? "종료" : "시작"))
                .widgetURL(URL(string: "widget://" + String(isTracking)))
        }
    }
}

//struct MediumView: View {
//    var state: HomeState
//    var body: some View {
//        Image(uiImage: state.snapshot)
//    }
//}
//
//struct LargeView: View {
//    var state: HomeState
//    var body: some View {
//
//    }
//}
