//
//  StatViewController.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import MapKit
import Photos
import RealmSwift

class PhotoCollectionVC: UIViewController {

    var journeyManager: JourneyManager! = nil
    var collectionView: UICollectionView! = nil
    
    let scale = UIScreen.main.scale
    var thumbnailSize = CGSize(width: 1024, height: 680)
    let cacheManager = PHCachingImageManager()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(journeyManager: JourneyManager) {
        super.init(nibName: nil, bundle: nil)
        self.journeyManager = journeyManager
        configureHierarchy()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
    }

    func configureHierarchy() {
        let collectionFrame = CGRect(x: 0, y: 130, width: view.bounds.width, height: view.bounds.height - 600)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: PhotoCollectionLayout(journeyManager: journeyManager))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.reuseIdentifier)
        collectionView.register(FirstCell.self, forCellWithReuseIdentifier: FirstCell.reuseIdentifier)
        collectionView.register(GroupCell.self, forCellWithReuseIdentifier: GroupCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView.decelerationRate = .fast
    }
    
    func flipToNote(indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        UIView.transition(with: cell, duration: 0.4, options: .transitionFlipFromRight, animations: cell.showNote)
    }
    
    func flipToPhoto(indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        UIView.transition(with: cell, duration: 0.4, options: .transitionFlipFromLeft, animations: cell.showPhoto)
    }
}

// MARK: - DataSource

extension PhotoCollectionVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return journeyManager.assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (journeyManager.expandedSection == section) ? journeyManager.assets[section].count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 { // first section
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstCell.reuseIdentifier,
                for: indexPath) as? FirstCell else { fatalError("Cannot create new cell") }
            return cell
        }
        if indexPath.section != journeyManager.expandedSection { // collapsed sections for footsteps
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.reuseIdentifier,
                for: indexPath) as? GroupCell else { fatalError("Cannot create new cell") }
            cell.journeyManager = journeyManager
            cell.section  = indexPath.section
            cell.configureCell()
            return cell
        } else { // expanded section
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier,
                for: indexPath) as? CardCell else { fatalError("Cannot create new cell") }
            cell.journeyManager = journeyManager
            cell.section = indexPath.section
            cell.item = indexPath.item
            cell.showPhoto()
            return cell
        }
    }
}

// MARK: - Other Classes

extension PhotoCollectionVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
        if cell.showingPhoto {
            flipToNote(indexPath: indexPath)
            cell.showingPhoto = false
        } else {
            flipToPhoto(indexPath: indexPath)
            cell.showingPhoto = true
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if journeyManager.bookmark.isEmpty { return }
        //journeyManager.moveSliderTo(value: journeyManager.bookmark[journeyManager.currentAssetNumber])
    }
    
}

class FirstCell: UICollectionViewCell {
    static let reuseIdentifier = "first-cell-reuse-identifier"
    var height: CGFloat {
        get { return contentView.frame.height }}
    var width: CGFloat {
        get { return contentView.frame.width }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let labelTop = UILabel()
        labelTop.text = "당신의 발자취,"
        labelTop.frame = CGRect(x: 20, y: height / 4, width: 200, height: 45)
        labelTop.font = UIFont(name: "NanumBarunpen-Bold", size: 35)
        labelTop.alpha = 0
        contentView.addSubview(labelTop)
        Timer.scheduledTimer(withTimeInterval: 0.55, repeats: false) { (_) in labelTop.alpha = 1}
        
        let labelBottom = UILabel()
        labelBottom.text = "돌아볼까요?"
        labelBottom.frame = CGRect(x: 20, y: height / 2, width: 179, height: 45)
        labelBottom.font = UIFont(name: "NanumBarunpen-Bold", size: 35)
        labelBottom.alpha = 0
        contentView.addSubview(labelBottom)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in labelBottom.alpha = 1}
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
}
