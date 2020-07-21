//
//  GroupCell.swift
//  footage
//
//  Created by Wootae on 7/14/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import Photos

class GroupCell: UICollectionViewCell {
    static let reuseIdentifier = "group-cell-reuse-identifier"
    let cacheManager = PHCachingImageManager()
    var assets: [Asset] = []
    var section = 0
    var journeyManager: JourneyManager! = nil
    var removeButton: UIButton! = nil
    var groupImage: UIView! = nil
    
    required init?(coder: NSCoder) {
        fatalError("not ")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandPhotos))
        addGestureRecognizer(tap)
    }
    
    func addGroupImage() {
        groupImage = journeyManager.groupImages[section]
        addSubview(groupImage)
    }
    
    @objc func expandPhotos() {
        journeyManager.expandedSection = section
        journeyManager.photoVC.collectionView.reloadSections(IndexSet(integer: section))
        journeyManager.photoVC.collectionView.scrollToItem(at: IndexPath(item: 0, section: section), at: .centeredHorizontally, animated: true)
    }
    
    func showRemove() {
        if removeButton == nil {
            removeButton = UIButton(frame: CGRect(x: PhotoCollectionLayout.groupWidth - 35, y: 35, width: 35, height: 35))
            removeButton.setImage(#imageLiteral(resourceName: "delete_button"), for: .normal)
            removeButton.addTarget(self, action: #selector(removeSection), for: .touchUpInside)
        }
        addSubview(removeButton)
    }
    
    func hideRemove() {
        if let removeButton = removeButton {
            removeButton.removeFromSuperview()
        }
    }
    
    @objc func removeSection() {
        journeyManager.removeSection(section: section)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupImage.removeFromSuperview()
    }
}
