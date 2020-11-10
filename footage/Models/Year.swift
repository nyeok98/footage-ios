//
//  JourneyData.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import RealmSwift

class Year: Object { // footsteps for a day
    
    let months = List<Month>()
    @objc dynamic var date = 0
    @objc dynamic var preview = #imageLiteral(resourceName: "basicStatsIcon").pngData()!
    
    required override init() {
        super.init()
    }
    
    init(date: Int) {
        super.init()
        self.date = date
    }
}
