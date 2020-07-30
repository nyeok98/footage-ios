//
//  NearbyCollectionVC.swift
//  footage
//
//  Created by Wootae on 7/22/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class BottomView: UIViewController {
    
    var collectionView: UICollectionView! = nil
    var collectionViewLayout: NearbyCollectionLayout! = nil
    var nearbyManager: NearbyManager! = nil
    var assets: [[Asset]] = []
    var currentIndexPath = IndexPath(item: 0, section: 0)
    let panRecognizer = UIPanGestureRecognizer()
    var viewState: ViewState = ViewState.small {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.view.frame = CGRect(origin: CGPoint.zero, size: self.viewState.size())
            }
            if viewState == ViewState.medium {
                showPhotos()
                print(view.frame)
                print(collectionView.frame)
            } else if viewState == ViewState.large {
                showNotes()
            } else {
                
            }
        }
    }
    
    enum ViewState: CGFloat {
        case small = 0.2
        case medium = 0.3
        case large = 0.6
        
        func size() -> CGSize {
            return CGSize(width: K.screenWidth, height: K.screenHeight * self.rawValue)
        }
    }
    
    init(nearbyManager: NearbyManager) {
        super.init(nibName: nil, bundle: nil)
        view.frame = CGRect(origin: CGPoint.zero, size: ViewState.small.size())
        view.backgroundColor = .clear
        self.nearbyManager = nearbyManager
        loadAssets()
        configureCollectionView()
        configurePanRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView() {
        collectionViewLayout = NearbyCollectionLayout(nearbyManager: nearbyManager)
        collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: ViewState.small.size()), collectionViewLayout: collectionViewLayout)
        collectionView.register(NearbyCell.self, forCellWithReuseIdentifier: NearbyCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    func loadAssets() {
        for footstepNumber in 0..<nearbyManager.orderedFootsteps.count {
            var assetsFootstep: [Asset] = []
            let footstep = nearbyManager.orderedFootsteps[footstepNumber]
            for assetIndex in 0..<footstep.notes.count {
                assetsFootstep.append(Asset(photo: footstep.photos[assetIndex], note: footstep.notes[assetIndex], footstepNumber: footstepNumber, color: footstep.color))
            }
            assets.append(assetsFootstep)
        }
    }
}

extension BottomView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearbyCell.reuseIdentifier, for: indexPath) as? NearbyCell else { fatalError("Cannot create new cell") }
        cell.indexPath = indexPath
        cell.asset = assets[indexPath.section][indexPath.item]
        if viewState == ViewState.medium { cell.showPhoto() }
        if viewState == ViewState.large { cell.showNote() }
        return cell
    }
    
}

extension BottomView: UICollectionViewDelegate {
    
}

extension BottomView {
    
    func configurePanRecognizer() {
        panRecognizer.addTarget(self, action: #selector(adjustViewFrame))
        panRecognizer.delegate = self
        view.addGestureRecognizer(panRecognizer)
    }
    
    @objc func adjustViewFrame(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let newHeight = view.frame.height + translation.y
        view.frame = CGRect(x: 0, y: 0, width: K.screenWidth, height: newHeight)
        recognizer.setTranslation(CGPoint.zero, in: view)
        nearbyManager.topViewChange(newHeight: newHeight)
        if recognizer.state == .ended {
            determineFinalState()
            nearbyManager.nearbyTableVC.determineFinalState()
        }
    }
    
    func determineFinalState() {
        let smallMax = (ViewState.small.rawValue + ViewState.medium.rawValue) / 2
        let mediumMax = (ViewState.medium.rawValue + ViewState.large.rawValue) / 2
        switch view.frame.height / K.screenHeight {
        case 0..<smallMax: viewState = ViewState.small
        case smallMax..<mediumMax: viewState = ViewState.medium
        default: viewState = ViewState.large }
    }
    
    func showNotes() {
        collectionView.frame.size.height = NearbyCell.noteHeight
        collectionViewLayout.itemSize =
            CGSize(width: NearbyCell.cellWidth, height: NearbyCell.noteHeight)
        for cell in collectionView.visibleCells {
            guard let nearbyCell = cell as? NearbyCell else { return }
            nearbyCell.showNote()
        }
    }
    
    func showPhotos() {
        collectionView.frame.size.height = NearbyCell.photoHeight
        collectionViewLayout.itemSize =
            CGSize(width: NearbyCell.cellWidth, height: NearbyCell.photoHeight)
        for cell in collectionView.visibleCells {
            guard let nearbyCell = cell as? NearbyCell else { return }
            nearbyCell.showPhoto()
        }
    }
}

extension BottomView: UIGestureRecognizerDelegate {
    
}
