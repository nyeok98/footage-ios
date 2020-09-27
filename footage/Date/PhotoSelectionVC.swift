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
    
    weak var journeyManager: JourneyManager! = nil
    var footstepNumber = 0
    
    var collectionView: UICollectionView! = nil
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
        let date = journeyManager.journey.date
        //let dateFrom = DateConverter.stringToDate(int: date, start: true)
        let dateFrom = NSDate(timeIntervalSince1970: 0) // DELETE!
        let dateTo = DateConverter.stringToDate(int: date, start: false) as NSDate
        fetchOptions.predicate = NSPredicate(format: "creationDate < %@ AND creationDate >= %@", dateTo, dateFrom as NSDate)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        let indexSet = IndexSet(integersIn: 0..<fetchResult!.count)
        cacheManager.startCachingImages(for: (fetchResult?.objects(at: indexSet))!, targetSize: thumbnailSize, contentMode: .default, options: nil)
        configureHierarchy()
        collectionView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        cacheManager.stopCachingImagesForAllAssets()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completePressed(_ sender: UIButton) {
        cacheManager.stopCachingImagesForAllAssets()
        let selectedPHAssets = fetchResult?.objects(at: selected) ?? []
        if selectedPHAssets.isEmpty {
            self.dismiss(animated: true)
            return
        }
        journeyManager.saveNewPhotos(pHAssets: selectedPHAssets, footstepNumber: footstepNumber)
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
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.select()
            selected.insert(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.deselect()
            selected.remove(indexPath.row)
        }
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
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)
    }
}



