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
    
    static var sliderIsMoving = false
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var assets: [Asset] = [] // identifiers for notes and photos
    var bookmark: [Int] = []
    var date = 0
    var journeyVC: JourneyViewController! = nil
    var previousIndex = 0 // for locating current cell
    
    let scale = UIScreen.main.scale
    var thumbnailSize = CGSize(width: 1024, height: 680)
    let cacheManager = PHCachingImageManager()
    
    enum Section {
        case main
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(date: Int, assets: [Asset], journeyVC: JourneyViewController) {
        super.init(nibName: nil, bundle: nil)
        self.date = date
        self.assets = assets
        self.journeyVC = journeyVC
        configureHierarchy()
    }
}

extension PhotoCollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    private func createLayout() -> UICollectionViewLayout {
        //        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        //        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
        //                                               heightDimension: .absolute(20))
        //        let badge = NSCollectionLayoutSupplementaryItem(
        //            layoutSize: badgeSize,
        //            elementKind: "badge-element-kind",
        //            containerAnchor: badgeAnchor)
        let itemSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [])
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureHierarchy() {
        let collectionFrame = CGRect(x: 0, y: 130, width: view.bounds.width, height: view.bounds.height - 600)
        
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.register(FirstCell.self, forCellWithReuseIdentifier: FirstCell.reuseIdentifier)
        collectionView.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.reuseIdentifier)
        collectionView.register(AddCell.self, forCellWithReuseIdentifier: AddCell.reuseIdentifier)
        
        collectionView.register(BadgeSupplementaryView.self,
                                forSupplementaryViewOfKind: "badge-element-kind", withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = false
        collectionView.isPrefetchingEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 || indexPath.item == assets.count + 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstCell.reuseIdentifier,
                for: indexPath) as? FirstCell else { fatalError("Cannot create new cell") }
            return cell
        }
        let asset = assets[indexPath.item - 1]
        if asset.photoFlag { // load photo
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier,
                for: indexPath) as? PhotoCell else { fatalError("Cannot create new cell") }
            self.cacheManager.requestImage(for: PHAsset.fetchAssets(withLocalIdentifiers: [asset.content], options: nil)[0], targetSize: self.thumbnailSize, contentMode: .default, options: nil) { (image, info) in
                cell.addImage(with: image)
            }
            return cell
        } else { // load note
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.reuseIdentifier,
                for: indexPath) as? NoteCell else { fatalError("Cannot create new cell") }
            cell.textView.text = asset.content
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if PhotoCollectionVC.sliderIsMoving {return}
        if indexPath.item == 0 && previousIndex == 0 {return}
        if indexPath.item - previousIndex == 1 {return}
        if indexPath.item > previousIndex {
            journeyVC.moveSliderTo(value: journeyVC.bookmark[indexPath.item - 2])
            previousIndex = indexPath.item - 1
        } else {
            if indexPath.item < journeyVC.bookmark.count {
                journeyVC.moveSliderTo(value: journeyVC.bookmark[indexPath.item])
                previousIndex = indexPath.item + 1
            }
        }
    }
    
    func addNoteCell() {}

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

class NoteCell: UICollectionViewCell, UITextViewDelegate {
    static let reuseIdentifier = "second-cell-reuse-identifier"
    var textView = UITextView()
    var height: CGFloat {
        get { return contentView.frame.height }}
    var width: CGFloat {
        get { return contentView.frame.width }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let button = UIButton()
        button.frame = CGRect(x: width * 0.8, y: height * 0.8, width: 50, height: 50)
        button.setImage(#imageLiteral(resourceName: "addWritingButton"), for: .normal)
        button.addTarget(self, action: #selector(activateTextField), for: .touchUpInside)
        textView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        textView.font = UIFont(name: "NanumBarunpen-Bold", size: 25)
        textView.autocorrectionType = .no
        textView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        textView.addGestureRecognizer(tap)
        contentView.addSubview(textView)
        contentView.addSubview(button)
        contentView.bringSubviewToFront(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    @objc func activateTextField() {
        textView.becomeFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        textView.resignFirstResponder()
    }
}

class AddCell: UICollectionViewCell, UITextViewDelegate {
    static let reuseIdentifier = "last-cell-reuse-identifier"
    var textView = UITextView()
    var height: CGFloat {
        get { return contentView.frame.height }}
    var width: CGFloat {
        get { return contentView.frame.width }}
    var journeyVC: JourneyViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let photoButton = UIButton(frame: CGRect(x: width / 2 - 40, y: height / 2 - 25, width: 80, height: 50))
        photoButton.setImage(#imageLiteral(resourceName: "postAddButton"), for: .normal)
        photoButton.addTarget(self, action: #selector(goToSelection), for: .touchUpInside)
        
        let button = UIButton()
        button.frame = CGRect(x: width * 0.8, y: height * 0.8, width: 50, height: 50)
        button.setImage(#imageLiteral(resourceName: "addWritingButton"), for: .normal)
        button.addTarget(self, action: #selector(activateTextField), for: .touchUpInside)
        textView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        textView.font = UIFont(name: "NanumBarunpen-Bold", size: 25)
        textView.autocorrectionType = .no
        textView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        textView.addGestureRecognizer(tap)
        contentView.addSubview(textView)
        contentView.addSubview(button)
        contentView.addSubview(photoButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    @objc func goToSelection() {
        journeyVC?.performSegue(withIdentifier: "goToPhotoSelection", sender: self)
    }
    
    @objc func activateTextField() {
        textView.becomeFirstResponder()
    }
    
    @objc func dismissKeyboard() {
        textView.resignFirstResponder()
    }
}
