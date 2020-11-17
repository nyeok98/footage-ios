//
//  NearbyCell.swift
//  footage
//
//  Created by Wootae on 7/22/20.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit

class MapCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "nearbycell"
    static let cellWidth = K.screenWidth * 0.8
    static let photoHeight: CGFloat = 200.0
    
    var asset: Asset! = nil
    var item: Int = 0
    var color: String { asset.color }
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: MapCollectionCell.photoHeight))
    let noteBackground = UIImageView(frame: CGRect(x: -8, y: MapCollectionCell.photoHeight + 10,
                                                   width: cellWidth + 16, height: MapCollectionCell.photoHeight))
    let noteView = UITextView(frame: CGRect(x: 10, y: MapCollectionCell.photoHeight + 20,
                                            width: cellWidth - 20, height: MapCollectionCell.photoHeight - 20))
    func showNote() {
        noteBackground.contentMode = .scaleToFill
        noteBackground.image = UIImage(named: color + "Paper")
        addSubview(noteBackground)
        noteView.font = UIFont(name: "NanumBarunpen-Bold", size: 15)
        noteView.text = asset.note
        noteView.isEditable = false
        noteView.isSelectable = false
        noteView.backgroundColor = .clear
        addSubview(noteView)
    }
    
    func showPhoto() {
        imageView.image = downSample(imageData: asset.photo, to: imageView.frame.size, scale: K.scale)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    func downSample(imageData: Data, to pointSize: CGSize, scale: CGFloat) -> UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions)!
        
        let maxDimentionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                  kCGImageSourceShouldCacheImmediately: true,
                                  kCGImageSourceCreateThumbnailWithTransform: true,
                                  kCGImageSourceThumbnailMaxPixelSize: maxDimentionInPixels] as CFDictionary
        let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions)!
        return UIImage(cgImage: downsampledImage)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.removeFromSuperview()
        noteBackground.removeFromSuperview()
        noteView.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
