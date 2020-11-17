//
//  Journey.swift
//  footage
//
//  Created by Wootae on 7/1/20.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import Foundation
import RealmSwift

struct Journey {
    var footsteps: List<Footstep>
    var preview: Data
    var reference: Object
    var date: Int
}
