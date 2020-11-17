//
//  JourneyData.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import Foundation
import RealmSwift

class Color: Object { // footsteps for a day
    
    @objc dynamic var date = 0
    @objc dynamic var distance = 0.0
    @objc dynamic var hex = ""
    
    required override init() {
        super.init()
    }
    
    init(date: Int, hex: String) {
        super.init()
        self.date = date
        self.hex = hex
    }
}
