//
//  SettingsCell.swift
//  footage
//
//  Created by 녘 on 2020/06/17.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var SettingsCellIconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            SettingsCellIconImage.image = #imageLiteral(resourceName: "SettingsCellIconSelected")
        } else {
            SettingsCellIconImage.image = #imageLiteral(resourceName: "SettingsCellImage")
        }
    }
}
