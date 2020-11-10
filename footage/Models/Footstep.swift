//
//  CoordinateByTime.swift
//  footage
//
//  Created by Wootae on 6/21/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class Footstep: Object {
    
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var color = "#EADE4Cff"
    @objc dynamic var setAsStart = false
    var coordinate: CLLocationCoordinate2D {
        get { return CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
    }
    
    let photos = List<Data>()
    let notes = List<String>()
    let owners = LinkingObjects(fromType: DayData.self, property: "footsteps")
    
    init(_ timestamp: Date, _ latitude: Double, _ longitude: Double, _ color: String, _ setAsStart: Bool) {
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
        self.color = color
        self.setAsStart = setAsStart
    }
    
    required override init() {
        super.init()
    }
}
