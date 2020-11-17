//
//  Asset.swift
//  footage
//
//  Created by Wootae on 7/7/20.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit

struct Asset: Comparable {
    var photo: Data
    var note: String
    var footstepNumber: Int
    var color: String = ""
    
    static func < (lhs: Asset, rhs: Asset) -> Bool {
         return lhs.footstepNumber < rhs.footstepNumber
    }
}
