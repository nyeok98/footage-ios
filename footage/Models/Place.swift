//
//  JourneyData.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class Place: Object { // footsteps for a day
    
    @objc dynamic var date = 0
    @objc dynamic var distance = 0.0
    @objc dynamic var country = ""
    @objc dynamic var administrativeArea = ""
    @objc dynamic var subAdministrativeArea = ""
    @objc dynamic var locality = ""
    @objc dynamic var subLocality = ""
    
    required init() {
        super.init()
    }
    
    init(date: Int, placemark: CLPlacemark) {
        super.init()
        self.date = date
        self.country = placemark.country ?? ""
        self.administrativeArea = placemark.administrativeArea ?? ""
        self.subAdministrativeArea = placemark.subAdministrativeArea ?? ""
        if placemark.locality == "세종특별자치시" {
            self.locality = placemark.subLocality ?? ""
        } else {
            self.locality = placemark.locality ?? ""
        }
        self.subLocality = placemark.subLocality ?? ""
    }
}
