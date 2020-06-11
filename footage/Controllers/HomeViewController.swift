//
//  ViewController.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var youString: UILabel!
    @IBOutlet weak var todayString: UILabel!
    @IBOutlet weak var triangle1: UIImageView!
    @IBOutlet weak var triangle2: UIImageView!
    @IBOutlet weak var triangle3: UIImageView!
    @IBOutlet weak var triangle4: UIImageView!
    @IBOutlet weak var triangle5: UIImageView!
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        //let homeAnimation = HomeAnimation()
        
        if startButton.currentImage == #imageLiteral(resourceName: "start_btn") {
            HomeAnimation.homeStartAnimation(self)
        } else {
            HomeAnimation.homeStopAnimation(self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startButton.setImage(#imageLiteral(resourceName: "start_btn"), for: .normal)
//        
    }


    

}


