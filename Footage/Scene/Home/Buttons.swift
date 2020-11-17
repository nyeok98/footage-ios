//
//  Buttons.swift
//  footage
//
//  Created by 녘 on 2020/06/24.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit

class Buttons {
    init(className: String) {
        if className == "YellowButton" {
            self.name = "YellowButton"
            self.color = "#EADE4Cff"
            self.image =  #imageLiteral(resourceName: "#EADE4Cff")
            self.imageBig =  #imageLiteral(resourceName: "#EADE4CffBig")
        } else if className == "PinkButton"  {
            self.name = "PinkButton"
            self.color = "#F5A997ff"
            self.image =  #imageLiteral(resourceName: "#F5A997ff")
            self.imageBig =  #imageLiteral(resourceName: "#F5A997ffBig")
        } else if className == "WhiteButton" {
            self.name = "WhiteButton"
            self.color = "#F0E7CFff"
            self.image =  #imageLiteral(resourceName: "#F0E7CFff")
            self.imageBig =  #imageLiteral(resourceName: "#F0E7CFffBig")
        } else if className == "OrangeButton" {
            self.name = "OrangeButton"
            self.color = "#FF6B39ff"
            self.image =  #imageLiteral(resourceName: "#FF6B39ff")
            self.imageBig =  #imageLiteral(resourceName: "#FF6B39ffBig")
        } else if className == "BlueButton" {
            self.name = "BlueButton"
            self.color = "#206491ff"
            self.image =  #imageLiteral(resourceName: "#206491ff")
            self.imageBig =  #imageLiteral(resourceName: "#206491ffBig")
        }
    }
    var name = "YellowButton"
    var color = "#EADE4Cff"
    var image: UIImage = #imageLiteral(resourceName: "#EADE4Cff")
    var imageBig: UIImage = #imageLiteral(resourceName: "#EADE4CffBig")
}
