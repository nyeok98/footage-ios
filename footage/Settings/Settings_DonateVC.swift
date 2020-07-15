//
//  Settings_DonateVC.swift
//  footage
//
//  Created by 녘 on 2020/07/06.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import StoreKit

class Settings_DonateVC: UIViewController {
    
    @IBOutlet weak var firstSectionLabel: UILabel!
    @IBOutlet weak var firstPrice: UILabel!
    @IBOutlet weak var secondSectionLabel: UILabel!
    @IBOutlet weak var secondPrice: UILabel!
    @IBOutlet weak var thirdSectionLabel: UILabel!
    @IBOutlet weak var thirdPrice: UILabel!
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
