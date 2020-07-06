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

class PhotoSelectionVC: UIViewController {

    var collectionView: UICollectionView! = nil
    var dateFrom: NSDate! = nil
    var dateTo: NSDate! = nil
    var photoCollectionVC: PhotoCollectionVC! = nil
    var selected = IndexSet()
    
    let cacheManager = PHCachingImageManager()
    var fetchResult: PHFetchResult<PHAsset>?
    // let scale = UIScreen.main.scale
    var thumbnailSize = CGSize(width: 121 * 2, height: 121 * 2)
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() { // FIX: Fetch must wait until permission granted!
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "creationDate < %@ AND creationDate >= %@", dateTo, dateFrom)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        let indexSet = IndexSet(integersIn: 0..<fetchResult!.count)
        cacheManager.startCachingImages(for: (fetchResult?.objects(at: indexSet))!, targetSize: thumbnailSize, contentMode: .default, options: nil)
        configureHierarchy()
        collectionView.reloadData()
    }
    
    @IBAction func completePressed(_ sender: UIButton) {
        let selectedAssets = fetchResult?.objects(at: selected) ?? []
        PhotoManager.saveAssets(assets: selectedAssets, date: DateConverter.dateToDay(date: dateFrom as Date))
        // fix: date?
        photoCollectionVC.assets = selectedAssets
        photoCollectionVC.configureDataSource()
        self.dismiss(animated: true) { }
    }
}

extension PhotoSelectionVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        if let asset = self.fetchResult?[indexPath.item] {
            cacheManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .default, options: nil) { (image, info) in
                cell.addImage(with: image)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: highlight and/or display check badge
        selected.insert(indexPath.row)
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .black
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selected.remove(indexPath.row)
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .white
    }
    
}

extension PhotoSelectionVC { // collection view configuration
    
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
        let collectionFrame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height - 100)
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



