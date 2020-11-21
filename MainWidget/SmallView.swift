//
//  SmallView.swift
//  footage
//
//  Created by Wootae on 10/11/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import SwiftUI

struct SmallView: View {
    let entry: WidgetEntry
    let isTracking = UserDefaults(suiteName: "group.footage")!.bool(forKey: "isTracking")
    let distanceToday = UserDefaults(suiteName: "group.footage")!.double(forKey: "distanceToday")
    var body: some View {
        ZStack {
            Image(entry.selectedColor + "Paper")
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 8) {
                let screenWidth = UIScreen.main.bounds.width
                if isTracking {
                    VStack(alignment: .center, spacing: 10) {
                        Text("오늘")
                            .font(.custom("NanumBarunpen-Bold", size: 20))
                        Text(String(format: "%.2f", distanceToday / 1000) + "km")
                            .font(.custom("NanumBarunpen", size: 28))
                    }
                } else {
                    VStack(alignment: .center, spacing: 10) {
                        Text("총")
                            .font(.custom("NanumBarunpen-Bold", size: 20))
                        Text(String(format: "%.2f", distanceToday / 1000) + "km")
                            .font(.custom("NanumBarunpen", size: 28))
                    }
                }
                Image(isTracking ? "stopButton" : "startButton")
                    .resizable()
                    .frame(width: screenWidth * 0.3, height: screenWidth * 0.14)
                    .widgetURL(URL(string: "widget://smallWidget"))
            }
        }
    }
}
