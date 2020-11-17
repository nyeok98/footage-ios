//
//  File.swift
//  footage
//
//  Created by Wootae on 7/14/20.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit

class PhotoCollectionLayout: UICollectionViewFlowLayout {
    
    static let cardWidth = UIScreen.main.bounds.width * 0.65
    static let cellHeight = UIScreen.main.bounds.height * 0.22
    static let groupWidth = UIScreen.main.bounds.width * 0.5
    weak var journeyManager: JourneyManager! = nil
    let activeDistance: CGFloat = 200
    let zoomFactor: CGFloat = 0.3
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
        self.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint { // TODO: consider direction
        guard let collectionView = collectionView else { return .zero }
        if let selectedPin = journeyManager.selectedPin {
            selectedPin.isSelected = false
        }
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
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance

            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.zIndex = Int(zoom.rounded())
            }
        }
        return rectAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
}
