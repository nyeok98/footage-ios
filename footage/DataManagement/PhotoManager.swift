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
    
    static func saveAssets(assets: [PHAsset], date: Int) {
        let realm = try! Realm()
        do { try realm.write {
            let object = realm.objects(PhotoAsset.self).filter("date == \(date)")
            var photoData: PhotoAsset
            if object.isEmpty {
                photoData = PhotoAsset(date: date)
                realm.add(photoData)
            } else {
                photoData = object[0]
            }
            for asset in assets {
                photoData.identifiers.append(asset.localIdentifier)
            }
        }} catch { print(error) }
    }
    
    static func loadAssets(date: Int) -> PHFetchResult<PHAsset> {
        let realm = try! Realm()
        let fetchResult = realm.objects(PhotoAsset.self).filter("date == \(date)")
        if fetchResult.isEmpty { return PHFetchResult() }
        return PHAsset.fetchAssets(withLocalIdentifiers: Array(fetchResult[0].identifiers), options: nil)
    }
}
