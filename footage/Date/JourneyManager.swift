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

class JourneyManager {
    
    // shared variables among JourneyVC, PhotoCollection, PhotoSelection
    
    var journeyVC: JourneyViewController! = nil
    var journeyIndex = 0
    var photoVC: PhotoCollectionVC! = nil
    
    var journey: Journey! = nil
    var assets: [[Asset]] = [[]] // first array should remain empty - corresponds to firstcell
    var bookmark: [Int] = [-1] // first item corrseponds to firstcell
    
    var sliderIsMoving = false
    var expandedSection = -1 // 0
    var currentIndexPath = IndexPath(item: 0, section: 0)
    
    init(journeyIndex: Int) {
        self.journeyIndex = journeyIndex
        self.journey = DateViewController.journeys[journeyIndex]
        loadAssets(footsteps: journey.footsteps)
    }
    
    // functions
    func loadAssets(footsteps: List<Footstep>) {
        for index in 0..<footsteps.count {
            let footstep = footsteps[index]
            if footstep.assets.isEmpty { continue }
            else {
                var assetGroup: [Asset] = []
                for assetString in footstep.assets { // TODO: change to map
                    let localIDNote = assetString.components(separatedBy: " ")
                    let asset = Asset(localID: localIDNote.first ?? "", note: localIDNote.last ?? "", footstepNumber: index)
                    assetGroup.append(asset)
                }
                assets.append(assetGroup)
                bookmark.append(index)
            }
            
        }
    }
    
    func moveSliderTo(value: Int) {
        DrawOnMap.moveCenterTo(journey.footsteps[value].coordinate, on: journeyVC.mainMap, centerMark: journeyVC.centerMark)
        journeyVC.slider.value = Float(value)
    }
    
    func findLocalIndex(assetIndex: Int) -> Int { // returns index of asset within a footstep
        let footstepNumber = bookmark[assetIndex]
        return assetIndex - (bookmark.firstIndex(of: footstepNumber) ?? 0)
    }
    
    func savePhotos(assets: [PHAsset], footstepNumber: Int, at index: Int) {
        let footstep = journey.footsteps[footstepNumber]
        let assets = assets.map { (asset) -> String in
            asset.localIdentifier + " "
        }
        let realm = try! Realm()
        do { try realm.write {
            footstep.assets.insert(contentsOf: assets, at: index)
        }} catch { print(error) }
    }
    
    func AddEmptyNote() {
//        let footstepNumber = assets[currentAssetNumber].footstepNumber
//        let footstep = journey.footsteps[footstepNumber]
//        let localIndex = findLocalIndex(assetIndex: newAssetNumber)
//        let realm = try! Realm()
//        do { try realm.write {
//            footstep.assets.insert("note ", at: localIndex)
//        }} catch { print(error) }
    }
    
    func editNote(content: String) {
//        let footstepNumber = assets[currentAssetNumber].footstepNumber
//        let footstep = journey.footsteps[footstepNumber]
//        let localIndex = findLocalIndex(assetIndex: currentAssetNumber)
//        let realm = try! Realm()
//        do { try realm.write {
//            footstep.assets.replace(index: localIndex, object: "note " + content)
//        }} catch { print(error) }
    }
    
}
