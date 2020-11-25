//
//  JourneyData.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import RealmSwift

class Month: Object { // footsteps for a day
    
    let days = List<DayData>()
    @objc dynamic var date = 0
    @objc dynamic var preview = #imageLiteral(resourceName: "basicStatsIcon").pngData()!
    let owners = LinkingObjects(fromType: Year.self, property: "months")
    
    required override init() {
        super.init()
    }
    
    init(date: Int) {
        super.init()
        self.date = date
    }
}
