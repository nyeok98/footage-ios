//
//  WidgetRealm.swift
//  footage
//
//  Created by Wootae on 10/18/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import RealmSwift

class WidgetRealm: Object {
    @objc var isTracking: Bool = false
    @objc var snapshot: Data = #imageLiteral(resourceName: "noDataImage").pngData()!
    
    required override init() {
        super.init()
    }
    
    init(isTracking: Bool, snapshot: Data) {
        self.isTracking = isTracking
        self.snapshot = snapshot
    }
}
