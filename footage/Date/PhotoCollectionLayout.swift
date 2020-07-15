//
//  File.swift
//  footage
//
//  Created by Wootae on 7/14/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class PhotoCollectionLayout: UICollectionViewFlowLayout {
    
    var journeyManager: JourneyManager! = nil
    var sideCellWidth: CGFloat { // width of next cell that appears on screen
        get {
            return (UIScreen.main.bounds.width - itemSize.width - minimumLineSpacing * 2) / 2
        }
    }
    
    init(journeyManager: JourneyManager) {
        super.init()
        self.journeyManager = journeyManager
        self.minimumLineSpacing = 10
        self.scrollDirection = .horizontal
        let cellWidth = UIScreen.main.bounds.width * 0.85
        self.itemSize = CGSize(width: cellWidth, height: UIScreen.main.bounds.height - 600)
        self.sectionInset = UIEdgeInsets(top: 0, left: sideCellWidth + minimumLineSpacing, bottom: 0, right: sideCellWidth + minimumLineSpacing)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }

        // Add some snapping behaviour so that the zoomed cell is always centered
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
                journeyManager.currentIndexPath = layoutAttributes.indexPath
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
