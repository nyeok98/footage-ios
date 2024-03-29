//
//  CardCell.swift
//  footage
//
//  Created by Wootae on 6/23/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import Photos

class CardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "photo-cell-reuse-identifier"
    var showingPhoto = true
    var tap: UITapGestureRecognizer!
    var imageView: UIImageView! = nil
    var textView: UITextView! = nil
    var noteButton: UIButton! = nil
    var removeButton: UIButton! = nil
    
    var journeyManager: JourneyManager! = nil
    var section = 0
    var item = 0
    
    let cacheManager = PHCachingImageManager()
    let scale = UIScreen.main.scale
    var thumbnailSize = CGSize(width: 1024, height: 680)
    var cellWidth: CGFloat = PhotoCollectionLayout.cardWidth
    var cellHeight: CGFloat = PhotoCollectionLayout.cellHeight
    
    var asset: Asset { return journeyManager.assets[section][item] }
    var photo: UIImage? { return journeyManager.downsample(imageData: asset.photo, to: contentView.frame.size, scale: UIScreen.main.scale) }
    var note: String { return asset.note }
    var color: String { return journeyManager.journey.footsteps[asset.footstepNumber].color }
    
    var editingText = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight))
        imageView.isUserInteractionEnabled = false
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func showRemove() {
        if removeButton == nil {
            removeButton = UIButton(frame: CGRect(x: cellWidth - (35 * 1.5), y: 35 / 2, width: 35, height: 35))
            removeButton.setImage(#imageLiteral(resourceName: "delete_button"), for: .normal)
            removeButton.addTarget(self, action: #selector(removeAsset), for: .touchUpInside)
        }
        self.addSubview(removeButton)
    }
    func hideRemove() {
        if let removeButton = removeButton {
            removeButton.removeFromSuperview()
        }
    }
    
    func showPhoto() {
        showingPhoto = true
        if let textView = textView, let noteButton = noteButton {
            textView.removeFromSuperview()
            noteButton.removeFromSuperview()
        }
        imageView.contentMode = .scaleAspectFit
        imageView.image = photo
    }
    
    @objc func removeAsset() {
        journeyManager.removeAsset(section: section, item: item)
    }

}

extension CardCell: UITextViewDelegate {
    
    
    func showNote() {
        showingPhoto = false
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: color + "Paper")
        
        if textView == nil {
            textView = UITextView(frame: CGRect(x: 10, y: 10, width: cellWidth - 20, height: cellHeight - 20))
            textView.font = UIFont(name: "NanumBarunpen", size: 12)
            textView.autocorrectionType = .no
            textView.backgroundColor = .clear
            textView.isEditable = false
            textView.isUserInteractionEnabled = false
            textView.textContainer.maximumNumberOfLines = 9
            textView.delegate = self
        }
        textView.text = note
        self.addSubview(textView)
        
        if noteButton == nil {
            noteButton = UIButton(frame: CGRect(x: cellWidth - (35 * 1.5), y: cellHeight - (35 * 1.5), width: 35, height: 35))
            noteButton.setImage(#imageLiteral(resourceName: "addWritingButton"), for: .normal)
            noteButton.addTarget(self, action: #selector(flipTextState), for: .touchUpInside)
        }
        self.addSubview(noteButton)
    }
    
    @objc func flipTextState() {
        if editingText {
            dismissAndSave()
            editingText = false
        } else {
            activateTextField()
            editingText = true
        }
    }
    
    func activateTextField() {
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.becomeFirstResponder()
        noteButton.frame = CGRect(x: cellWidth - (40 * 1.5), y: cellHeight - (30 * 1.5), width: 45, height: 30)
        noteButton.setImage(#imageLiteral(resourceName: "complete_button"), for: .normal)
    }
    
    func dismissAndSave() {
        textView.resignFirstResponder()
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        journeyManager.saveNewNote(content: textView.text, section: section, item: item)
        noteButton.frame = CGRect(x: cellWidth - (35 * 1.5), y: cellHeight - (35 * 1.5), width: 35, height: 35)
        noteButton.setImage(#imageLiteral(resourceName: "addWritingButton"), for: .normal)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(.zero, animated: false)
        textView.text.removeLast()
    }
    
}
