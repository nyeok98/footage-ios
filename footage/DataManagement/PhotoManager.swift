//
//  PhotoManager.swift
//  footage
//
//  Created by Wootae on 7/6/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import RealmSwift
import Photos

class PhotoManager {
    
    static func savePhotos(assets: [PHAsset], footstep: Footstep) {
        let realm = try! Realm()
        do { try realm.write {
            for asset in assets {
                footstep.photos.append(asset.localIdentifier)
            }
        }} catch { print(error) }
    }
    
    static func saveNote(note: String, footstep: Footstep) {
        let realm = try! Realm()
        do { try realm.write {
            footstep.notes.append(note)
        }} catch { print(error) }
    }
    
    static func loadAssetsAndBookmark(footsteps: List<Footstep>) -> ([Asset], [Int]) {
        var assets: [Asset] = []
        var bookmark: [Int] = []
        for index in 0..<footsteps.count {
            let footstep = footsteps[index]
            for identifier in footstep.photos {
                assets.append(Asset(photoFlag: true, content: identifier, index: index))
                bookmark.append(index)
            }
            for note in footstep.notes {
                assets.append(Asset(photoFlag: false, content: note, index: index))
                bookmark.append(index)
            }
        }
        return (assets, bookmark)
    }
    
}
