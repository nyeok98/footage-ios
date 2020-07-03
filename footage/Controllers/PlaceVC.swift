//
//  PlaceVC.swift
//  footage
//
//  Created by 녘 on 2020/06/30.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import EFCountingLabel

class PlaceVC: UIViewController {
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var firstContent: UIView!
    @IBOutlet weak var secondContent: UIView!
    @IBOutlet weak var thirdContent: UIView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    @IBOutlet weak var thirdStack: UIStackView!
    
    
    @IBAction func goBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        secondButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
        secondContent.alpha = 0
        thirdButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
        thirdContent.alpha = 0
        PlaceAnimation.firstIsLarge(placeVC: self)
//        firstView.layer.borderWidth = 2
//        firstView.layer.borderColor = .init(srgbRed: 100, green: 0, blue: 0, alpha: 1)
//        secondView.layer.borderWidth = 2
//        secondView.layer.borderColor = .init(srgbRed: 100, green: 0, blue: 0, alpha: 1)
//        thirdView.layer.borderWidth = 2
//        thirdView.layer.borderColor = .init(srgbRed: 100, green: 0, blue: 0, alpha: 1)
        firstStack.bounds.origin.x -= 30
        secondStack.bounds.origin.x -= 30
        thirdStack.bounds.origin.x -= 30
        firstStack.bounds.origin.y -= 20
        secondStack.bounds.origin.y -= 20
        thirdStack.bounds.origin.y -= 20
        
    }
    
    @IBAction func firstplaceButtonPressed(_ sender: UIButton) {
        PlaceAnimation.firstIsLarge(placeVC: self)
    }
    @IBAction func secondplaceButtonPressed(_ sender: UIButton) {
        PlaceAnimation.secondIsLarge(placeVC: self)
    }
    @IBAction func thirdplaceButtonPressed(_ sender: UIButton) {
        PlaceAnimation.thirdIsLarge(placeVC: self)
    }
    
    func loadData() {
        
    }
    
}
