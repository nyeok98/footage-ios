//
//  mapCell.swift
//  footage
//
//  Created by Wootae on 6/12/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class MapCell: UICollectionViewCell {
    

    var journeyData = JourneyData()
    
    
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    static let reuseIdentifier = "map-cell-reuse-identifier"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapImage.layer.shadowColor = UIColor.black.cgColor
        mapImage.layer.shadowOpacity = 1
        mapImage.layer.shadowOffset = .zero
        mapImage.layer.shadowRadius = 10
    }

}
