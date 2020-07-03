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
    
    override func viewDidLoad() {
        let days = DateConverter.lastMondaySunday()
        let result = ColorManager.getRankingDistance(startDate: days.0, endDate: days.1)
        if result.count > 0 {
            firstColor.image = UIImage(named: result[0].key)
            //firstColorDistance.text = String(format: "%.2f", (result[0].value) / 1000)
        }
        if result.count > 1 {
            secondColor.image = UIImage(named: result[1].key)
            //secondColorDistance.text = String(format: "%.2f", (result[1].value) / 1000)
        }
        if result.count > 2 {
            thirdColor.image = UIImage(named: result[2].key)
            //thirdColorDistance.text = String(format: "%.2f", (result[2].value) / 1000)
        }
        if result.count > 3 {
            fourthColor.image = UIImage(named: result[3].key)
            //fourthColorDistance.text = String(format: "%.2f", (result[3].value) / 1000)
        }
        if result.count > 4 {
            fifthColor.image = UIImage(named: result[4].key)
            //fifthColorDistance.text = String(format: "%.2f", (result[4].value) / 1000)
        }
    }
}
