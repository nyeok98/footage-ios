//
//  TotalDistance.swift
//  footage
//
//  Created by Wootae on 6/20/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import RealmSwift

class Distance: Object { // must be initailizaed once and only once at installation
    
    required override init() {
        super.init()
    }
    
    @objc dynamic var total: Double = 0
    @objc dynamic var today: Double = 0
    
}
