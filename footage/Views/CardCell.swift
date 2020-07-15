//
//  CardCell.swift
//  footage
//
//  Created by Wootae on 6/23/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import Photos

class CardCell: UICollectionViewCell, UITextViewDelegate { // 사용자가 사진 지우면 어떡할꺼?
    
    static let reuseIdentifier = "photo-cell-reuse-identifier"
    var showingPhoto = true
    var imageView = UIImageView()
    var textView = UITextView()
    var tap: UITapGestureRecognizer!
    var button = UIButton()
    
    var journeyManager: JourneyManager! = nil
    var section = 0
    var item = 0
    
    let cacheManager = PHCachingImageManager()
    let scale = UIScreen.main.scale
    var thumbnailSize = CGSize(width: 1024, height: 680)
    
    var asset: Asset { return journeyManager.assets[section][item] }
    var photo: UIImage {
        get {
            var toReturn = UIImage()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.version = .original
            cacheManager.requestImage(for: PHAsset.fetchAssets(withLocalIdentifiers: [asset.localID], options: nil)[0], targetSize: self.thumbnailSize, contentMode: .default, options: options) { (image, info) in
                toReturn = image ?? UIImage() // change to default photo?
            }
            return toReturn
        }
    }
    var note: String { return asset.note }
    var color: String { return journeyManager.journey.footsteps[asset.footstepNumber].color }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = contentView.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    func showPhoto() {
        showingPhoto = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = photo
        textView.removeFromSuperview()
        button.removeFromSuperview()
    }
    
    func showNote() {
        showingPhoto = false
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: color + "Paper")
        button.frame = CGRect(x: frame.width * 0.8, y: frame.height * 0.75, width: 50, height: 50)
        button.setImage(#imageLiteral(resourceName: "addWritingButton"), for: .normal)
        button.addTarget(self, action: #selector(activateTextField), for: .touchUpInside)
        textView.text = note
        textView.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.height - 20)
        textView.font = UIFont(name: "NanumBarunpen-Bold", size: 25)
        textView.autocorrectionType = .no
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissAndSave))
        contentView.addSubview(textView)
        contentView.addSubview(button)
    }
    
    @objc func activateTextField() {
        textView.becomeFirstResponder()
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.addGestureRecognizer(tap)
    }
        
    @objc func dismissAndSave() {
        textView.resignFirstResponder()
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.removeGestureRecognizer(tap)
        journeyManager.assets[section][item].note = textView.text
    }
    
//    let frame = CGRect(x: view.bounds.width * 0.05 , y: 130, width: view.bounds.width * 0.9, height: view.bounds.height - 600)

}
