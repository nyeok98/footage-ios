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
    
    var allMedia: PHFetchResult<PHAsset>?
    let scale = UIScreen.main.scale
    var thumbnailSize = CGSize.zero
    
    enum Section {
        case main
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(journey: JourneyData) {
        super.init(nibName: nil, bundle: nil)
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "creationDate < %@", Date() as NSDate)
        self.allMedia = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        self.thumbnailSize = CGSize(width: 1024 * self.scale, height: 1024 * self.scale)
        self.journey = journey
        configureHierarchy()
        self.collectionView.reloadData()
        // loadData()
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
        if count == 0 {
            collectionView.backgroundColor = .clear
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        let asset = self.allMedia?[indexPath.item]
        LocalImageManager.shared.requestIamge(with: asset, thumbnailSize: self.thumbnailSize) { (image) in
            cell.configure(with: image)
        }
        // cell.layer.cornerRadius = 50 ??? 왜 안돼?
        return cell
    }
    
//    func loadData() {
//        self.allMedia = PHAsset.fetchAssets(with: nil)
//
//    }
}

// MARK: - Image Manager

final class LocalImageManager {
    
    static var shared = LocalImageManager()
    
    fileprivate let imageManager = PHImageManager()
    
    var representedAssetIdentifier: String?
    
    func requestIamge(with asset: PHAsset?, thumbnailSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        guard let asset = asset else {
            completion(nil)
            return
        }
        self.representedAssetIdentifier = asset.localIdentifier
        self.imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, info in
            // UIKit may have recycled this cell by the handler's activation time.
            //  print(info?["PHImageResultIsDegradedKey"])
            // Set the cell's thumbnail image only if it's still showing the same asset.
            if self.representedAssetIdentifier == asset.localIdentifier {
                completion(image)
            }
        })
    }
}

