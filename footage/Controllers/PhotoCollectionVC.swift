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

class PhotoCollectionVC: UIViewController {
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var assets: [PHAsset] = []
    
    let scale = UIScreen.main.scale
    var thumbnailSize = CGSize(width: 1024, height: 680)
    let cacheManager = PHCachingImageManager()
    
    enum Section {
        case main
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureHierarchy()
        configureDataSource()
        // load from realm and occupy assets with selected photos
    }
}

extension PhotoCollectionVC {
    private func createLayout() -> UICollectionViewLayout {
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
                                               heightDimension: .absolute(20))
        let badge = NSCollectionLayoutSupplementaryItem(
            layoutSize: badgeSize,
            elementKind: "badge-element-kind",
            containerAnchor: badgeAnchor)
        let itemSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
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
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.register(BadgeSupplementaryView.self,
                                forSupplementaryViewOfKind: "badge-element-kind", withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = false
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCell.reuseIdentifier,
                for: indexPath) as? PhotoCell else { fatalError("Cannot create new cell") }
            self.cacheManager.requestImage(for: self.assets[identifier], targetSize: self.thumbnailSize, contentMode: .default, options: nil) { (image, info) in
                cell.addImage(with: image)
            }
            return cell
        }
        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if let badgeView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier,
                for: indexPath) as? BadgeSupplementaryView {
                return badgeView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<assets.count))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

