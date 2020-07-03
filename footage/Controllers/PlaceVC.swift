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
    
    let bigHeight = 200
    let smallHeight = 80
    let spacing = 10
    let ceiling = 100
    let leading = 25
    let bigFrame = CGSize(width: 327, height: 200)
    let smallFrame = CGSize(width: 327, height: 79)
    
    override func viewDidLoad() {
        firstIsLarge()
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
       firstIsLarge()
    }
    @IBAction func secondplaceButtonPressed(_ sender: UIButton) {
        secondIsLarge()
    }
        
    @IBAction func thirdplaceButtonPressed(_ sender: UIButton) {
        thirdIsLarge()
    }
    
    func firstIsLarge() {
        firstView.frame.origin = CGPoint(x: leading, y: ceiling)
        secondView.frame.origin = CGPoint(x: leading, y: ceiling + bigHeight + spacing)
        thirdView.frame.origin = CGPoint(x: leading, y: ceiling + bigHeight + smallHeight + spacing * 2)
        firstButton.frame.origin = CGPoint(x: 0, y: 0)
        secondButton.frame.origin = CGPoint(x: 0, y: 0)
        thirdButton.frame.origin = CGPoint(x: 0, y: 0)
        firstView.frame.size = bigFrame
        secondView.frame.size = smallFrame
        thirdView.frame.size = smallFrame
        firstContent.alpha = 1
        secondContent.alpha = 0
        thirdContent.alpha = 0
        firstButton.setImage(#imageLiteral(resourceName: "firstplaceSection"), for: .normal)
        secondButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
        thirdButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
    }
    
    func secondIsLarge() {
        firstView.frame.origin = CGPoint(x: leading, y: ceiling)
        secondView.frame.origin = CGPoint(x: leading, y: ceiling + smallHeight + spacing)
        thirdView.frame.origin = CGPoint(x: leading, y: ceiling + smallHeight + bigHeight + spacing * 2)
        firstView.frame.size = bigFrame
        secondView.frame.size = smallFrame
        thirdView.frame.size = smallFrame
        firstContent.alpha = 0
        secondContent.alpha = 1
        thirdContent.alpha = 0
        firstButton.imageView?.frame.size = smallFrame
        secondButton.imageView?.frame.size = bigFrame
        thirdButton.imageView?.frame.size = smallFrame
        firstButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
        secondButton.setImage(#imageLiteral(resourceName: "firstplaceSection"), for: .normal)
        thirdButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
    }
    
    func thirdIsLarge() {
        firstView.frame.origin = CGPoint(x: leading, y: ceiling)
        secondView.frame.origin = CGPoint(x: leading, y: ceiling + smallHeight + spacing)
        thirdView.frame.origin = CGPoint(x: leading, y: ceiling + smallHeight + smallHeight + spacing * 2)
        firstView.frame.size = bigFrame
        secondView.frame.size = smallFrame
        thirdView.frame.size = smallFrame
        firstContent.alpha = 0
        secondContent.alpha = 0
        thirdContent.alpha = 1
        firstButton.imageView?.frame.size = smallFrame
        secondButton.imageView?.frame.size = smallFrame
        thirdButton.imageView?.frame.size = bigFrame
        firstButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
        secondButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
        thirdButton.setImage(#imageLiteral(resourceName: "firstplaceSection"), for: .normal)
    }
    
    func loadData() {
        
    }
    
}
