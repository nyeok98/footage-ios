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
    
    var label = UILabel()
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
                cellArray[i].journeyData.previewImage = journeyArray[i].previewImage
            }
            view.bringSubviewToFront(collectionView)
        }
        snapshot.appendSections([.main])
        snapshot.appendItems(cellArray)
        dataSource.apply(snapshot, animatingDifferences: false)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        configureOthers()
        let labelFrame = CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 100)
        label.frame = labelFrame
        label.text = "새로운 발자취를 기록해 볼까요?"
        label.font = UIFont(name: "NanumSquare", size: 20)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.backgroundColor = .clear
        self.view.addSubview(label)
        view.bringSubviewToFront(label)
    }
}

extension StatsViewController {
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [])
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
        let collectionFrame = CGRect(x: 0, y: 270, width: view.bounds.width, height: view.bounds.height - 355)
        
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: createLayout())
        
        collectionView.isPagingEnabled = true
        // collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView.delegate = self
        
        // Register Components
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: MapCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        view.sendSubviewToBack(collectionView)
        view.sendSubviewToBack(label)
    }
}



// MARK: configure view data source

extension StatsViewController {
    private func configureDataSource() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM ddd"
        dataSource = UICollectionViewDiffableDataSource<Section, MapCell>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: MapCell) -> UICollectionViewCell? in
            
            // Get a cell of the desired kind.
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MapCell.reuseIdentifier,
                for: indexPath) as? MapCell else { fatalError("Could not create new cell") }
            
            // Populate the cell with our item description.
            cell.mapImage.image = StatsViewController.journeyArray.last!.previewImage
            let today = NSString(string: StatsViewController.journeyArray[indexPath.row].date)
            cell.label.text = today.substring(from: 5)
            // cell.mapImage.layer.cornerRadius = 20
            // cell.mapImage.layer.masksToBounds = true
            
            // Return the cell.
            return cell
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
        
        performSegue(withIdentifier: "goToJourney", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! JourneyViewController
        destinationVC.forReloadStatsVC = self
        destinationVC.journeyData = StatsViewController.journeyArray.last
    }
    
    private func configureOthers() {
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
//        let radius = bounds.width / 2.0
//        layer.cornerRadius = radius
//        layer.borderColor = UIColor.black.cgColor
//        layer.borderWidth = 1.0
    }

}


