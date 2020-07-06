//
//  PhotoAsset.swift
//  footage
//
//  Created by Wootae on 7/6/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import RealmSwift

class PhotoAsset: Object { // footsteps for a day
    
    @objc dynamic var date = 0
    let identifiers = List<String>()
    
    required init() {
        super.init()
    }
    
    init(date: Int) {
        super.init()
        self.date = date
    }
}
