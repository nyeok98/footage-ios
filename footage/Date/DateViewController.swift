//
//  DateViewController.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import MapKit
import EFCountingLabel

class DateViewController: UIViewController {
    
    var profileImage: UIImage?
    
    @IBOutlet weak var rangeControl: UISegmentedControl!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    static var journeys: [Journey] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MapCell>! = nil
    var collectionView: UICollectionView! = nil
    
    static let badgeElementKind = "badge-element-kind"
    enum Section {
        case main
    }
    
    @IBAction func dateRangeChanged(_ sender: UISegmentedControl) {
        loadWithRange(sender.selectedSegmentIndex)
    }
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        loadWithRange(rangeControl.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        if let profileData = UserDefaults.standard.data(forKey: "profileImage") {
            profileImage = UIImage(data: profileData)!
        }
        if let profileID = UserDefaults.standard.string(forKey: "userName") {
            profileName.text = profileID
        }
        reloadProfileImage()
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

// MARK: -configure view frame hierarchy

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
            
            cell.mapImage.image = UIImage(data: DateViewController.journeys[indexPath.row].preview)
            let date = DateViewController.journeys[indexPath.row].date
            
            switch date {
            case ...10000: cell.label.text = String(date) + "년"
            case 10001...1000000: cell.label.text = String(date / 100) + "년 " + String(date % 100) + "월"
            default:
                cell.label.text =  String(date / 100 % 100) + "월 " + String(date % 100) + "일"
            }
            
            return cell
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, MapCell>()
        var cellArray: [MapCell] = []
        let journeys = DateViewController.journeys
        if !journeys.isEmpty {
            for i in 0...journeys.count - 1 {
                cellArray.append(MapCell())
                cellArray[i].journey = journeys[i]
            }
        } else {
        }
        snapshot.appendSections([.main])
        snapshot.appendItems(cellArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension DateViewController {
    
    func reloadProfileImage() {
        profileView.layer.cornerRadius = profileView.bounds.width / 2.0
        profileView.image = profileImage
    }
    
    private func loadWithRange(_ range: Int) {
        DateViewController.journeys = []
        var snapshot = NSDiffableDataSourceSnapshot<Section, MapCell>()
        var cellArray: [MapCell] = []
        switch range {
        case 0: for journey in DateManager.loadFromRealm(rangeOf: "day") {
            DateViewController.journeys.append(journey)
        }
        case 1: for journey in DateManager.loadFromRealm(rangeOf: "month") {
            DateViewController.journeys.append(journey)
        }
        // case 2
        default: for journey in DateManager.loadFromRealm(rangeOf: "year") {
            DateViewController.journeys.append(journey)
        }
        }
        
        if !DateViewController.journeys.isEmpty {
            for i in 0...DateViewController.journeys.count - 1 {
                cellArray.append(MapCell())
                cellArray[i].journey = DateViewController.journeys[i]
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
            destinationVC.journeyManager = JourneyManager(journeyIndex: sender as! Int)
            destinationVC.dateVC = self
        default: break
        }
    }
}
