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
    
    init(timestamp: Date, coordinate: CLLocationCoordinate2D, isNewStartingPoint: Bool) {
        self.timestamp = timestamp
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.isNewStartingPoint = isNewStartingPoint
    }
    
    required init() {
        super.init()
    }
    
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    @objc dynamic var isNewStartingPoint: Bool = false
    let owners = LinkingObjects(fromType: Route.self, property: "footsteps")
}
