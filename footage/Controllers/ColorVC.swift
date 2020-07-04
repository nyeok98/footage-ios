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
    var ranking: Array<(key: String, value: Double)> = []
    
    override func viewDidLoad() {
        loadData()
    }
    
    @IBAction func goBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func colorPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToColoredJourney", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        let destinationVC = segue.destination as! ColoredJourneyVC
        destinationVC.color = ranking[button.tag].key
        
    }
    
    
    func loadData() {
        if ranking.count > 0 {
            firstColor.image = UIImage(named: ranking[0].key)
            firstColorDistance.text = String(format: "%.2f", (ranking[0].value) / 1000)
        }
        if ranking.count > 1 {
            secondColor.image = UIImage(named: ranking[1].key)
            secondColorDistance.text = String(format: "%.2f", (ranking[1].value) / 1000)
        }
        if ranking.count > 2 {
            thirdColor.image = UIImage(named: ranking[2].key)
            thirdColorDistance.text = String(format: "%.2f", (ranking[2].value) / 1000)
        }
        if ranking.count > 3 {
            fourthColor.image = UIImage(named: ranking[3].key)
            fourthColorDistance.text = String(format: "%.2f", (ranking[3].value) / 1000)
        }
        if ranking.count > 4 {
            fifthColor.image = UIImage(named: ranking[4].key)
            fifthColorDistance.text = String(format: "%.2f", (ranking[4].value) / 1000)
        }
    }
}
