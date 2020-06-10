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
        
        if startButton.currentImage == #imageLiteral(resourceName: "start_btn") {
            startButton.setImage(#imageLiteral(resourceName: "stop_btn"), for: .normal)
            todayString.text = "오늘,"
            youString.text = "당신이 새로 남긴"
            //home화면 삼각형 사각형으로 바꾸는 부분.
            UIView.transition(with: triangle1,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.triangle1.image = UIImage(named: "square1") },
                              completion: nil)
            UIView.transition(with: triangle2,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.triangle2.image = UIImage(named: "square2") },
                              completion: nil)
            UIView.transition(with: triangle3,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.triangle3.image = UIImage(named: "square3") },
                              completion: nil)
            UIView.transition(with: triangle4,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.triangle4.image = UIImage(named: "square4") },
                              completion: nil)
            UIView.transition(with: triangle5,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.triangle5.image = UIImage(named: "square2") },
                              completion: nil)
            
        } else {
            startButton.setImage(#imageLiteral(resourceName: "start_btn"), for: .normal)
            todayString.text = "오늘까지"
            youString.text = "당신이 남긴"
            UIView.transition(with: triangle1,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.triangle1.image = UIImage(named: "triangle") },
                              completion: nil)
            UIView.transition(with: triangle2,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.triangle2.image = UIImage(named: "triangle-1") },
                              completion: nil)
            UIView.transition(with: triangle3,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.triangle3.image = UIImage(named: "triangle-2") },
                              completion: nil)
            UIView.transition(with: triangle4,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.triangle4.image = UIImage(named: "triangle-3") },
                              completion: nil)
            UIView.transition(with: triangle5,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.triangle5.image = UIImage(named: "triangle-4") },
                              completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        
    }


    

}


