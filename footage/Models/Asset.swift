//
//  Asset.swift
//  footage
//
//  Created by Wootae on 7/7/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation

struct Asset: Comparable {
    var photoFlag: Bool // true for photo, false for note
    var content: String // PHAssetID for photo, content for note
    var index: Int // index of footstep related to this asset
    
    static func < (lhs: Asset, rhs: Asset) -> Bool {
         return lhs.index < rhs.index
    }
}
