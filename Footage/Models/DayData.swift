//
//  JourneyData.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class DayData: Object { // footsteps for a day
    
    @objc dynamic var date = 0
    @objc dynamic var distance = 0.0
    @objc dynamic var preview = #imageLiteral(resourceName: "basicStatsIcon").pngData()!
    let footsteps = List<Footstep>()
    let owners = LinkingObjects(fromType: Month.self, property: "days")
    
    required override init() {
        super.init()
    }
    
    init(date: Int) {
        super.init()
        self.date = date
    }
}
