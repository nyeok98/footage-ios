//
//  mapCell.swift
//  footage
//
//  Created by Wootae on 6/12/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class MapCell: UICollectionViewCell {    
    
    var mapImage = UIImageView()
    var journeyData = JourneyData()
    
    static let reuseIdentifier = "map-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mapImage)
        mapImage.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(0)
        NSLayoutConstraint.activate([ // set insets: mapImage vs. MapCell
            mapImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            mapImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            mapImage.topAnchor.constraint(equalTo:
                contentView.topAnchor, constant: inset),
            mapImage.bottomAnchor.constraint(equalTo:
                contentView.bottomAnchor, constant: -inset)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

