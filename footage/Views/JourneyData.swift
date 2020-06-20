//
//  JourneyData.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit

class JourneyData: NSObject {
    
    override init() {
        super.init()
    }
    
    init(polylines: [[CLLocationCoordinate2D]], date: String) {
        self.polylineArray = polylines
        self.date = date
    }
    
    var polylineArray: [[CLLocationCoordinate2D]] = []
    var date: String = ""
    var finishTime: String = ""
    var previewImage: UIImage = #imageLiteral(resourceName: "basicStatsIcon")
    
}
