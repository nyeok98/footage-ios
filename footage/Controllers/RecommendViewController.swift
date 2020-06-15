//
//  RecommandViewController.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class RecommendViewController: UIViewController, UICollectionViewDelegate {
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    enum Section: String, CaseIterable {
        case nearby = "당신 근처의"
        case travel = "여행"
        case walk = "산책"
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
//    var baseURL: URL?
//
////    convenience init(withAlbumsFromDirectory directory: URL) {
////        self.init()
////        baseURL = directory
////    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Your Albums"
        configureHierachy()
        configureDataSource()
    }
}

extension RecommendViewController {
    func configureHierachy() {
        let collectionFrame = CGRect(x: 10, y: 150, width: view.bounds.width - 20, height: view.bounds.height - 200)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: MapCell.reuseIdentifier)
        collectionView.register(
            TitleSupplementaryView.self,
            forSupplementaryViewOfKind: RecommendViewController.sectionHeaderElementKind,
            withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        view.addSubview(collectionView)
    }
}

extension RecommendViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <Section, Int>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, int: Int) -> UICollectionViewCell? in
                let sectionType = Section.allCases[indexPath.section]
                switch sectionType {
                
                case .travel:
                  guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCell.reuseIdentifier, for: indexPath) as? MapCell
                      else { fatalError("Cannot create new cell") }
                  
                  // Populate the cell with our item description.
                  cell.mapImage.image = #imageLiteral(resourceName: "map1")
                  // Return the cell.
                  return cell

                case .walk:
                  guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCell.reuseIdentifier, for: indexPath) as? MapCell
                      else { fatalError("Cannot create new cell") }
                  
                  // Populate the cell with our item description.
                  cell.mapImage.image = #imageLiteral(resourceName: "map1")
                  // Return the cell.
                  return cell

                case .nearby:
                  guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCell.reuseIdentifier, for: indexPath) as? MapCell
                      else { fatalError("Cannot create new cell") }
                  
                  // Populate the cell with our item description.
                  cell.mapImage.image = #imageLiteral(resourceName: "map1")
                  // Return the cell.
                  return cell
                
                }
        }
        
        dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleSupplementaryView.reuseIdentifier,
                for: indexPath) as? TitleSupplementaryView else { fatalError("Cannot create header view") }
            
            // Populate the cell
            supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
            
            return supplementaryView
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.travel])
        snapshot.appendItems(Array(0..<5))
        snapshot.appendSections([.walk])
        snapshot.appendItems(Array(5..<10))
        snapshot.appendSections([.nearby])
        snapshot.appendItems(Array(10..<15))
        dataSource.apply(snapshot, animatingDifferences: false)
        
//        let snapshot = snapshotForCurrentState()
//        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension RecommendViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch (sectionLayoutKind) {
            case .nearby: return self.generateSectionLayout()
            case .travel: return self.generateSectionLayout()
            case .walk: return self.generateSectionLayout()
            }
        }
        return layout
    }
    
    func generateSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: RecommendViewController.sectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
}

//extension RecommendViewController {
//    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, MapCell> {
////        let nearbySuggestions = [MapCell.self]
////        let travelSuggestions = Array(MapCell)
////        let walkSuggestions = Array(MapCell)
//
//
//      var snapshot = NSDiffableDataSourceSnapshot<Section, MapCell>()
////      snapshot.appendSections([Section.nearby])
////      snapshot.appendItems(nearbySuggestions)
////
////      snapshot.appendSections([Section.travel])
////      snapshot.appendItems(sharedAlbums)
////
////      snapshot.appendSections([Section.walk])
////      snapshot.appendItems(allAlbums)
//      return snapshot
//    }
//}
