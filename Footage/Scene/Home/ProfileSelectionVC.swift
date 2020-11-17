//
//  StatViewController.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit
import MapKit
import Photos

class ProfileSelectionVC: UIViewController {

    var collectionView: UICollectionView! = nil
    var dateFrom: NSDate = Date(timeIntervalSince1970: 0) as NSDate // long time ago
    var dateTo: NSDate = Date() as NSDate // today
    var parentVC: UIViewController?
    let cacheManager = PHCachingImageManager()
    var allMedia: PHFetchResult<PHAsset>?
    let scale = UIScreen.main.scale
    var thumbnailSize = CGSize(width: 121 * 2, height: 121 * 2)
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "creationDate < %@ AND creationDate >= %@", dateTo, dateFrom)
        allMedia = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        let indexSet = IndexSet(integersIn: 0..<allMedia!.count)
        cacheManager.startCachingImages(for: (allMedia?.objects(at: indexSet))!, targetSize: thumbnailSize, contentMode: .default, options: nil)
        configureHierarchy()
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        cacheManager.stopCachingImagesForAllAssets() // important!
    }
    
}

extension ProfileSelectionVC {
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [])
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureHierarchy() {
        let collectionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = false
        collectionView.allowsSelection = true
        view.addSubview(collectionView)
    }
}

// MARK: configure view data source

extension ProfileSelectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = allMedia?.count ?? 0
        if count == 0 {
            collectionView.backgroundColor = .clear
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        if let asset = self.allMedia?[self.allMedia!.count - indexPath.item - 1] {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
                //PHImageManager.default()
            cacheManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .default, options: options) { (image, info) in
                cell.addImage(with: image)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPhotoEdit", sender: self.allMedia!.count - indexPath.item - 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProfileEditVC
        destinationVC.imageAsset = allMedia?[sender as! Int]
        destinationVC.parentVC = self
        destinationVC.statsVC = self.parentVC
    }
}



