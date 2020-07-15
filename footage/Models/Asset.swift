//
//  Asset.swift
//  footage
//
//  Created by Wootae on 7/7/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation

struct Asset: Comparable {
    var localID: String // true for photo, false for note
    var note: String // PHAssetID for photo, content for note
    var footstepNumber: Int // index of footstep related to this asset
    // var showingPhoto = true
    
    static func < (lhs: Asset, rhs: Asset) -> Bool {
         return lhs.footstepNumber < rhs.footstepNumber
    }
}
