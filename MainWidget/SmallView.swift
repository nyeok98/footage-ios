//
//  SmallView.swift
//  footage
//
//  Created by Wootae on 10/11/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import SwiftUI

struct SmallView: View {
    let selectedColor: String
    let widgetSize: CGSize
    let isTracking = UserDefaults(suiteName: "group.footage")!.bool(forKey: "isTracking")
    let distanceToday = UserDefaults(suiteName: "group.footage")!.double(forKey: "distanceToday")
    let distanceTotal = UserDefaults(suiteName: "group.footage")!.double(forKey: "distanceTotal")
    
    var distanceToShow: String {
        if isTracking { return String(format: "%.2f", distanceToday / 1000) + "km" }
        else { return String(format: "%.f", distanceTotal / 1000) + "km" }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            let screenWidth = UIScreen.main.bounds.width
            TopView(selectedColor: selectedColor, isTracking: isTracking)
            Text(distanceToShow)
                .font(.custom("NanumBarunpen", size: 35))
            Image(isTracking ? "stopButton" : "startButton")
                .resizable()
                .frame(width: screenWidth * 0.3, height: screenWidth * 0.14)
                .widgetURL(URL(string: "widget://smallWidget"))
        }.padding(.top, 10)
    }
}

struct TopView: View {
    let selectedColor: String
    let isTracking: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 7, content: {
            Image(selectedColor).resizable()
                .frame(width: 20, height: 32, alignment: .center)
            let selectedCategory = UserDefaults(suiteName: "group.footage")!.string(forKey: selectedColor) ?? "노란색"
            Text(isTracking ? selectedCategory : "총")
                .font(.custom("NanumBarunpen-Bold", size: 22))
                .frame(width: 100, alignment: .leading)
        })
    }
}
