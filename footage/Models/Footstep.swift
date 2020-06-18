//
//  CoordinateByTime.swift
//  footage
//
//  Created by Wootae on 6/21/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit

struct Footstep {
    var timestamp: Date
    var coordinate: CLLocationCoordinate2D
    var isNewStartingPoint: Bool
}
