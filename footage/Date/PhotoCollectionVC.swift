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
        let collectionFrame = CGRect(x: 0, y: K.screenHeight * 0.15, width: view.bounds.width, height: K.screenHeight * 0.3)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: PhotoCollectionLayout(journeyManager: journeyManager))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.reuseIdentifier)
        collectionView.register(FirstCell.self, forCellWithReuseIdentifier: FirstCell.reuseIdentifier)
        collectionView.register(GroupCell.self, forCellWithReuseIdentifier: GroupCell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
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
            cell.addGroupImage()
            if journeyManager.removeActivated { cell.showRemove() }
            else { cell.hideRemove() }
            return cell
        } else { // expanded section
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier,
                for: indexPath) as? CardCell else { fatalError("Cannot create new cell") }
            cell.journeyManager = journeyManager
            cell.section = indexPath.section
            cell.item = indexPath.item
            cell.showPhoto()
            if journeyManager.removeActivated { cell.showRemove() }
            else { cell.hideRemove() }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else { fatalError("Cannot create new header") }
        if indexPath.section != 0 {
            header.configure(footstepNumber: journeyManager.bookmark.lastIndex(of: indexPath.section)!)
        }
        return header
    }
    
}

// MARK: - Other Classes

extension PhotoCollectionVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.main.bounds.width / 1.3, height: UIScreen.main.bounds.height * 0.22)
        }
        if indexPath.section == journeyManager.expandedSection {
            return CGSize(width: UIScreen.main.bounds.width * 0.65, height: UIScreen.main.bounds.height * 0.22)
        } else {
            return CGSize(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.22)
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if journeyManager.currentIndexPath.section != journeyManager.expandedSection {
            let sectionToCollapse = journeyManager.expandedSection
            journeyManager.expandedSection = -1
            if sectionToCollapse > 0 && sectionToCollapse < collectionView.numberOfSections {
                collectionView.reloadSections(IndexSet(integer: sectionToCollapse))
                collectionView.scrollToItem(at: IndexPath(item: 0, section: journeyManager.currentIndexPath.section), at: .centeredHorizontally, animated: false)
            }
        }
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
        labelTop.frame = CGRect(x: 40, y: height / 4, width: 200, height: 45)
        labelTop.font = UIFont(name: "NanumBarunpen-Bold", size: 25)
        labelTop.alpha = 0
        contentView.addSubview(labelTop)
        Timer.scheduledTimer(withTimeInterval: 0.55, repeats: false) { (_) in labelTop.alpha = 1}
        
        let labelBottom = UILabel()
        labelBottom.text = "돌아볼까요?"
        labelBottom.frame = CGRect(x: 40, y: height / 2, width: 179, height: 45)
        labelBottom.font = UIFont(name: "NanumBarunpen-Bold", size: 25)
        labelBottom.alpha = 0
        contentView.addSubview(labelBottom)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in labelBottom.alpha = 1}
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}
