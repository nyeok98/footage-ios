//
//  StatViewController.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var rangeControl: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    static var journeyArray: [JourneyData] = []
    
    static let badgeElementKind = "badge-element-kind"
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MapCell>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        var snapshot = NSDiffableDataSourceSnapshot<Section, MapCell>()
        var cellArray: [MapCell] = []
        let journeyArray = StatsViewController.journeyArray
        if !journeyArray.isEmpty {
            for i in 0...journeyArray.count - 1 {
                cellArray.append(MapCell())
                cellArray[i].journeyData = journeyArray[i]
            }
            view.bringSubviewToFront(collectionView)
        }
        snapshot.appendSections([.main])
        snapshot.appendItems(cellArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        configureOthers()
        let labelFrame = CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 100)
        let label = UILabel(frame: labelFrame)
        label.text = "새로운 발자취를 기록해 볼까요? 홈 화면으로 가서 start 눌러서 기록하고 다시오세요 동녘이 바보"
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.backgroundColor = .clear
        self.view.addSubview(label)
        view.bringSubviewToFront(label)
    }
}

extension StatsViewController {
    private func createLayout() -> UICollectionViewLayout {
        
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.bottom], fractionalOffset: CGPoint(x: 0, y: 1))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
                                              heightDimension: .absolute(20))
        let badge = NSCollectionLayoutSupplementaryItem(
            layoutSize: badgeSize,
            elementKind: StatsViewController.badgeElementKind,
            containerAnchor: badgeAnchor)
        
        let itemSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.45))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets.leading = 20
        group.contentInsets.trailing = 20
        group.contentInsets.bottom = 20
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}



// MARK: configure view frame hierarchy

extension StatsViewController {
    private func configureHierarchy() {
        let collectionFrame = CGRect(x: 0, y: 270, width: view.bounds.width, height: view.bounds.height - 400)
        
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: createLayout())
        
        collectionView.isPagingEnabled = true
        // collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView.delegate = self
        
        // Register Components
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: MapCell.reuseIdentifier)
        collectionView.register(DateSupplementaryView.self,
        forSupplementaryViewOfKind: StatsViewController.badgeElementKind,
        withReuseIdentifier: DateSupplementaryView.reuseIdentifier)
        //
        
        view.addSubview(collectionView)
    }
}



// MARK: configure view data source

extension StatsViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MapCell>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: MapCell) -> UICollectionViewCell? in
            
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MapCell.reuseIdentifier,
                for: indexPath) as? MapCell else { fatalError("Could not create new cell") }
            
            // Populate the cell with our item description.
            cell.mapImage.image = cell.journeyData.previewImage
            // cell.mapImage.layer.cornerRadius = 20
            // cell.mapImage.layer.masksToBounds = true
            
            // Return the cell.
            return cell
        }
        dataSource.supplementaryViewProvider = {
            (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            // Get a supplementary view of the desired kind.
            if let badgeView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DateSupplementaryView.reuseIdentifier,
                for: indexPath) as? DateSupplementaryView {
                badgeView.label.text = "\(Int.random(in: 1...12))월 \(Int.random(in: 1...28))일"
                //badgeView.isHidden = !hasBadgeCount

                // Return the view.
                return badgeView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, MapCell>()
        var cellArray: [MapCell] = []
        let journeyArray = StatsViewController.journeyArray
        if !journeyArray.isEmpty {
            for i in 0...journeyArray.count - 1 {
                cellArray.append(MapCell())
                cellArray[i].journeyData = journeyArray[i]
            }
        } else {
        }
        snapshot.appendSections([.main])
        snapshot.appendItems(cellArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension StatsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("item selected")
        performSegue(withIdentifier: "goToJourney", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! JourneyViewController
        destinationVC.journeyData = StatsViewController.journeyArray[0]
    }
    
    private func configureOthers() {
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
//        let radius = bounds.width / 2.0
//        layer.cornerRadius = radius
//        layer.borderColor = UIColor.black.cgColor
//        layer.borderWidth = 1.0
    }

}


