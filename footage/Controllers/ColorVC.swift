//
//  ColorVC.swift
//  footage
//
//  Created by 녘 on 2020/06/30.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import EFCountingLabel

class ColorVC: UIViewController {
    @IBOutlet weak var firstColor: UIImageView!
    @IBOutlet weak var secondColor: UIImageView!
    @IBOutlet weak var thirdColor: UIImageView!
    @IBOutlet weak var fourthColor: UIImageView!
    @IBOutlet weak var fifthColor: UIImageView!
    @IBOutlet weak var firstColorDistance: EFCountingLabel!
    @IBOutlet weak var secondColorDistance: EFCountingLabel!
    @IBOutlet weak var thirdColorDistance: EFCountingLabel!
    @IBOutlet weak var fourthColorDistance: EFCountingLabel!
    @IBOutlet weak var fifthColorDistance: EFCountingLabel!
    
    @IBAction func goBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
