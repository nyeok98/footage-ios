//
//  JourneyData.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit

class JourneyData: NSObject { // Stats 에서 하나의 셀 -> Journey 화면을 구성하는 데이터형
    
    override init() {
        super.init()
    }
    
    init(polylines: [[Footstep]], date: String) {
        self.footstepArray = polylines
        self.date = date
    }
    
    var footstepArray: [[Footstep]] = []
    var date: String = ""
    var previewImage: UIImage = #imageLiteral(resourceName: "basicStatsIcon")
}
