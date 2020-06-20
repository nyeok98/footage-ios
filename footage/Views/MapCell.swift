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
    var label = UILabel()
    var journeyData = JourneyData()
    var labelHeight = CGFloat(20)
    
    static let reuseIdentifier = "map-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        mapImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mapImage)
        let inset = CGFloat(0)
        NSLayoutConstraint.activate([ // set insets: mapImage vs. MapCell
            mapImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            mapImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            mapImage.topAnchor.constraint(equalTo:
                contentView.topAnchor, constant: inset),
            mapImage.bottomAnchor.constraint(equalTo:
                contentView.bottomAnchor, constant: -labelHeight)
        ])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "NanumSquareRegular", size: 10)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: labelHeight),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

