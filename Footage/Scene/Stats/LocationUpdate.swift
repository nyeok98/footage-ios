//
//  DataCollector.swift
//  footage
//
//  Created by Wootae on 6/30/20.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class LocationUpdate {

    static var lastLocation: CLLocation?

    static func processNewLocation(location: CLLocation, distance: Double, setAsStart: Bool, color: String) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let timestamp = location.timestamp
        let footstep = Footstep(timestamp, latitude, longitude, color, setAsStart)
        DateManager.update(footstep: footstep, distance: distance)
        if !setAsStart {
            let distance = location.distance(from: LocationUpdate.lastLocation ?? location)
            ColorManager.update(hex: color, distance: distance)
            PlaceManager.update(latitude: latitude, longitude: longitude, distance: distance)
        }
        LocationUpdate.lastLocation = location
    }
}

