//
//  Route.swift
//  footage
//
//  Created by Wootae on 6/19/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class Route: Object {
    
    init(withSingle: Footstep) {
        super.init()
        self.footsteps.append(withSingle)
    }
    
    required init() {
        super.init()
    }
    
    let footsteps = List<Footstep>()
    let owners = LinkingObjects(fromType: JourneyData.self, property: "routes")
    @objc dynamic var distance: Double = 0
}
