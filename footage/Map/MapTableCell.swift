//
//  NearbyTableCell.swift
//  footage
//
//  Created by Wootae on 7/22/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class MapTableCell: UITableViewCell {
    
    static let reuseIdentifier = "nearbytablecell"
    var footstep: Footstep! = nil
    var distance = 0.0
    var footstepImage = UIImageView(frame: CGRect(x: 10, y: 15, width: 40, height: 40))
    var timeLabel = UILabel(frame: CGRect(x: 60, y: 12, width: 200, height: 30))
    var distanceLabel = UILabel(frame: CGRect(x: 60, y: 32, width: 200, height: 30))
    var categoryLabel = UILabel(frame: CGRect(x: 120, y: 32, width: 200, height: 30))
    var photoCountLabel = UILabel(frame: CGRect(x: 250, y: 20, width: 200, height: 30))
    var noteCountLabel = UILabel(frame: CGRect(x: 300, y: 20, width: 200, height: 30))
    
    
    func configureCell() {
        backgroundColor = UIColor(hex: footstep.color)?.withAlphaComponent(0.5)
        
        footstepImage.image = #imageLiteral(resourceName: "addFootstep")
        addSubview(footstepImage)
        
        let date = DateConverter.dateToDay(date: footstep.timestamp)
        timeLabel.text = String(date / 10000) + "년 " + String(date % 10000 / 100) + "월 " + String(date % 100) + "일"
        timeLabel.font = UIFont(name: "NanumBarunpen-Bold", size: 20)
        addSubview(timeLabel)
        
        distanceLabel.text = String(format: "%.2f", distance) + "km"
        distanceLabel.font = UIFont(name: "NanumBarunpen", size: 15)
        addSubview(distanceLabel)
        
        categoryLabel.text = UserDefaults.standard.string(forKey: footstep.color)
        categoryLabel.font = UIFont(name: "NanumBarunpen", size: 15)
        addSubview(categoryLabel)
        
        photoCountLabel.text = "사진: " + String(footstep.photos.count)
        photoCountLabel.font = UIFont(name: "NanumBarunpen", size: 15)
        addSubview(photoCountLabel)
        
        noteCountLabel.text = "글: " + String(footstep.notes.filter({$0 != ""}).count)
        noteCountLabel.font = UIFont(name: "NanumBarunpen", size: 15)
        addSubview(noteCountLabel)
    }

}
