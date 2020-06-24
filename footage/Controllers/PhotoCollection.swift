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

class PhotoCollection: UIViewController {

    var collectionView: UICollectionView! = nil
    var journey: JourneyData = JourneyData()
    let dateFormatter = DateFormatter()
    var allMedia: PHFetchResult<PHAsset>?
    let scale = UIScreen.main.scale
    var thumbnailSize = CGSize(width: 1024, height: 680)
    let cacheManager = PHCachingImageManager()
    
    enum Section {
        case main
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(journey: JourneyData) {
        super.init(nibName: nil, bundle: nil)
        dateFormatter.dateFormat = "yyyyMMdd"
        let fetchOptions = PHFetchOptions()
        if let today = dateFormatter.date(from: String(journey.date)) {
        fetchOptions.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate < %@", today as NSDate, Date() as NSDate) // TODO: fix for month and year
        }
        self.allMedia = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        let indexSet = IndexSet(integersIn: 0..<allMedia!.count)
        cacheManager.startCachingImages(for: (allMedia?.objects(at: indexSet))!, targetSize: thumbnailSize, contentMode: .default, options: nil)
        self.journey = journey
        configureHierarchy()
        self.collectionView.reloadData()
    }
}

extension PhotoCollection {
    private func createLayout() -> UICollectionViewLayout {
        
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
        let collectionFrame = CGRect(x: 0, y: 130, width: view.bounds.width, height: view.bounds.height - 570)
        
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = false
    }
}

// MARK: configure view data source

extension PhotoCollection: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = allMedia?.count ?? 0
        if count == 0 { collectionView.backgroundColor = .clear }
        if count > 50 { return 50 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        if let asset = self.allMedia?[indexPath.item] {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            cacheManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .default, options: options) { (image, info) in
                cell.addImage(with: image)
            }
        }
        return cell
    }
}

