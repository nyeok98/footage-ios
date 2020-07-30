//
//  collectionVC.swift
//  footage
//
//  Created by Wootae on 7/29/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import RealmSwift

class MapCollectionVC: UIViewController {
    
    var assets: [Asset] = []
    
    let collectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: K.screenWidth, height: K.screenHeight), collectionViewLayout: MapCollectionLayout())
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        collectionView.register(MapCollectionCell.self, forCellWithReuseIdentifier: MapCollectionCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
    }
    
    func reload(with footstep: Footstep) {
        assets.removeAll()
        for assetIndex in 0..<footstep.notes.count {
            assets.append(Asset(photo: footstep.photos[assetIndex], note: footstep.notes[assetIndex],
                                footstepNumber: 0, color: footstep.color))
        }
        collectionView.reloadData()
    }
}

extension MapCollectionVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCollectionCell.reuseIdentifier, for: indexPath) as? MapCollectionCell else { fatalError("Cannot create new cell") }
        cell.item = indexPath.item
        cell.asset = assets[indexPath.item]
        cell.showPhoto()
        cell.showNote()
        cell.frame.origin.y = 0
        return cell
    }
}

extension MapCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: MapCollectionCell.cellWidth, height: MapCollectionCell.photoHeight * 2 + 10)
    }
    
}
