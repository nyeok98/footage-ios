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
    var imageSize = CGSize(width: 1024, height: 680)
    var randomDegree: CGFloat {
        get { return CGFloat.random(in: -0.3...0.3) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configureCell() { // render image with stacked photos + add tap recongnizer
        assets = journeyManager.assets[section]
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.version = .original
        for asset in assets {
            var assetImage: UIImage!
            cacheManager.requestImage(for: PHAsset.fetchAssets(withLocalIdentifiers: [asset.localID], options: nil)[0], targetSize: imageSize, contentMode: .default, options: options) { (image, info) in
                assetImage = image
            }
            let imageView = UIImageView(frame: CGRect(x: (frame.width - 200) / 2, y: (frame.height - 150) / 2,
                                                      width: 200, height: 150))
            imageView.image = assetImage
            imageView.transform = imageView.transform.rotated(by: randomDegree)
            imageView.isUserInteractionEnabled = false // for tap recognizer
            contentView.addSubview(imageView)
            contentView.sendSubviewToBack(imageView)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandPhotos))
        contentView.addGestureRecognizer(tap)
    }
    
    @objc func expandPhotos() {
        journeyManager.expandedSection = section
        journeyManager.photoVC.collectionView.reloadSections(IndexSet(integer: section))
        // reload current section and display each asset
    }
}
