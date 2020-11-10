//
//  WidgetView.swift
//  footage
//
//  Created by Wootae on 10/11/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import RealmSwift

struct HomeState {
    var isTracking: Bool
    var distanceToday: Double
    
    static func create() -> HomeState {
        guard let userDefaults = UserDefaults(suiteName: "group.footage") else {
            return HomeState(isTracking: false, distanceToday: 0.0)
        }
        let isTracking = userDefaults.bool(forKey: "isTracking")
        print(isTracking)
        let distanceToday = userDefaults.double(forKey: "distanceToday")
        print(distanceToday)
        return HomeState(isTracking: isTracking, distanceToday: distanceToday)
    }
}
