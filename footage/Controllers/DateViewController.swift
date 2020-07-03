//
//  StatViewController.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import MapKit
import EFCountingLabel

class DateViewController: UIViewController {
    @IBOutlet weak var rangeControl: UISegmentedControl!
    @IBOutlet weak var profileView: UIImageView!
    var profileImage = #imageLiteral(resourceName: "profile")
    @IBOutlet weak var totalDistance: EFCountingLabel!
    
    //var label = UILabel()
    static var journeyArray: [JourneyData] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MapCell>! = nil
    var collectionView: UICollectionView! = nil
    
    static let badgeElementKind = "badge-element-kind"
    enum Section {
        case main
    }
    
    @IBAction func dateRangeChanged(_ sender: UISegmentedControl) {
        loadWithRange(sender.selectedSegmentIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        loadWithRange(rangeControl.selectedSegmentIndex)
        totalDistance.setUpdateBlock { (value, label) in
            label.text = String(format: "%.f", value)
        }
        totalDistance.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 7)
        totalDistance.countFrom(0, to: CGFloat(HomeViewController.distanceTotal / 1000), withDuration: 5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        if let profileData = UserDefaults.standard.data(forKey: "profileImage") {
            profileImage = UIImage(data: profileData)!}
        reloadProfileImage()
        configureLabel()
    }
}

extension DateViewController {
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [])
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.53))
        
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

extension DateViewController {
    private func configureHierarchy() {
        let collectionFrame = CGRect(x: 0, y: 320, width: view.bounds.width, height: view.bounds.height - 405)
        
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: createLayout())
        collectionView.delegate = self
        
        collectionView.isPagingEnabled = true
        //collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        
        // Register Components
        collectionView.register(UINib(nibName: "MapCell", bundle: nil), forCellWithReuseIdentifier: MapCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        view.sendSubviewToBack(collectionView)
        //view.sendSubviewToBack(label)
    }
}



// MARK: configure view data source

extension DateViewController {
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
            if let imageData = DateViewController.journeyArray[indexPath.row].previewImage {
                cell.mapImage.image = UIImage(data: imageData)
            } else {
                cell.mapImage.image = #imageLiteral(resourceName: "basicStatsIcon")
            }
            let date = DateViewController.journeyArray[indexPath.row].date
            var dateLabel = ""
            
            switch date {
            case ...10000: dateLabel = String(date) + "년"
            case 10001...1000000: dateLabel = String(date / 100) + "년 " + String(date % 100) + "월"
            default:
                dateLabel =  String(date / 100 % 100) + "월 " + String(date % 100) + "일"
            }
            
            cell.label.text = dateLabel
            
            // Return the cell.
            return cell
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, MapCell>()
        var cellArray: [MapCell] = []
        let journeyArray = DateViewController.journeyArray
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

extension DateViewController {
    
    func configureLabel() {
        let label = UILabel()
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
    
    func reloadProfileImage() {
        profileView.layer.cornerRadius = profileView.bounds.width / 2.0
        profileView.image = profileImage
    }
    
    
    
    private func loadWithRange(_ range: Int) {
        DateViewController.journeyArray = []
        var snapshot = NSDiffableDataSourceSnapshot<Section, MapCell>()
        var cellArray: [MapCell] = []
        switch range {
        case 0: for journeyData in DataManager.loadFromRealm(rangeOf: "day") {
                DateViewController.journeyArray.append(journeyData)
        }
        case 1: for journeyData in DataManager.loadFromRealm(rangeOf: "month") {
            DateViewController.journeyArray.append(journeyData)
        }
        // case 2
        default: for journeyData in DataManager.loadFromRealm(rangeOf: "year") {
            DateViewController.journeyArray.append(journeyData)
        }
        }
        
        if !DateViewController.journeyArray.isEmpty {
            for i in 0...DateViewController.journeyArray.count - 1 {
                cellArray.append(MapCell())
                cellArray[i].journeyData = DateViewController.journeyArray[i]
            }
            view.bringSubviewToFront(collectionView)
        }
        snapshot.appendSections([.main])
        snapshot.appendItems(cellArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension DateViewController: UICollectionViewDelegate {
    @IBAction func changePressed(_ sender: Any) {
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToJourney", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToProfile":
            let destinationVC = segue.destination as! ProfileSelectionVC
            destinationVC.parentVC = self
        case "goToJourney":
            let destinationVC = segue.destination as! JourneyViewController
            destinationVC.journeyIndex = sender as! Int
            destinationVC.forReloadStatsVC = self
            destinationVC.journeyData = DateViewController.journeyArray[sender as! Int]
        default: break
        }
    }
}
