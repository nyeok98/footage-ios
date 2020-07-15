//
//  PlaceAnimation.swift
//  footage
//
//  Created by 녘 on 2020/07/03.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class PlaceAnimation {
    
    static let bigHeight = 209
    static let smallHeight = 79
    static let spacing = 10
    static let ceiling = 100
    static let leading = 25
    static let bigFrame = CGSize(width: 327, height: 209)
    static let smallFrame = CGSize(width: 327, height: 79)
    
    static func firstIsLarge(placeVC: PlaceVC) {
        if placeVC.secondButton.currentImage == #imageLiteral(resourceName: "firstplaceSection") {
            placeVC.secondButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
            placeVC.secondContent.alpha = 0
        } else if placeVC.thirdButton.currentImage == #imageLiteral(resourceName: "firstplaceSection") {
            placeVC.thirdButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
            placeVC.thirdContent.alpha = 0
        }
        UIView.animate(withDuration: 1) {
            placeVC.firstView.frame.origin = CGPoint(x: leading, y: ceiling)
            placeVC.secondView.frame.origin = CGPoint(x: leading, y: ceiling + bigHeight + spacing)
            placeVC.thirdView.frame.origin = CGPoint(x: leading, y: ceiling + bigHeight + smallHeight + spacing * 2)
            placeVC.firstButton.frame.origin = CGPoint(x: 0, y: 0)
            placeVC.secondButton.frame.origin = CGPoint(x: 0, y: 0)
            placeVC.thirdButton.frame.origin = CGPoint(x: 0, y: 0)
            
            
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            UIView.animate(withDuration: 0.5) {
                placeVC.firstContent.alpha = 1
            }
            placeVC.firstView.frame.size = bigFrame
            placeVC.secondView.frame.size = smallFrame
            placeVC.thirdView.frame.size = smallFrame
            placeVC.firstButton.setImage(#imageLiteral(resourceName: "firstplaceSection"), for: .normal)
        }
        
    }
    
    static func secondIsLarge(placeVC: PlaceVC) {
        
        if placeVC.firstButton.currentImage == #imageLiteral(resourceName: "firstplaceSection") {
            placeVC.firstButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
            placeVC.firstContent.alpha = 0
        } else if placeVC.thirdButton.currentImage == #imageLiteral(resourceName: "firstplaceSection") {
            placeVC.thirdButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
            placeVC.thirdContent.alpha = 0
        }
        
        UIView.animate(withDuration: 1) {
            placeVC.firstView.frame.origin = CGPoint(x: leading, y: ceiling)
            placeVC.secondView.frame.origin = CGPoint(x: leading, y: ceiling + smallHeight + spacing)
            placeVC.thirdView.frame.origin = CGPoint(x: leading, y: ceiling + smallHeight + bigHeight + spacing * 2)
            placeVC.firstView.frame.size = bigFrame
            placeVC.secondView.frame.size = smallFrame
            placeVC.thirdView.frame.size = smallFrame
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            UIView.animate(withDuration: 0.5) {
                placeVC.secondContent.alpha = 1
            }
            placeVC.firstButton.imageView?.frame.size = smallFrame
            placeVC.secondButton.imageView?.frame.size = bigFrame
            placeVC.thirdButton.imageView?.frame.size = smallFrame
            placeVC.secondButton.setImage(#imageLiteral(resourceName: "firstplaceSection"), for: .normal)
        }
        
        
        
    }
    
    static func thirdIsLarge(placeVC: PlaceVC) {
        if placeVC.firstButton.currentImage == #imageLiteral(resourceName: "firstplaceSection") {
            placeVC.firstButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
            placeVC.firstContent.alpha = 0
        } else if placeVC.secondButton.currentImage == #imageLiteral(resourceName: "firstplaceSection") {
            placeVC.secondButton.setImage(#imageLiteral(resourceName: "placeSection"), for: .normal)
            placeVC.secondContent.alpha = 0
        }
        UIView.animate(withDuration: 1) {
            placeVC.firstView.frame.origin = CGPoint(x: leading, y: ceiling)
            placeVC.secondView.frame.origin = CGPoint(x: leading, y: ceiling + smallHeight + spacing)
            placeVC.thirdView.frame.origin = CGPoint(x: leading, y: ceiling + smallHeight + smallHeight + spacing)
            placeVC.firstView.frame.size = bigFrame
            placeVC.secondView.frame.size = smallFrame
            placeVC.thirdView.frame.size = smallFrame
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            UIView.animate(withDuration: 0.5) {
                placeVC.thirdContent.alpha = 1
            }
            placeVC.firstButton.imageView?.frame.size = smallFrame
            placeVC.secondButton.imageView?.frame.size = smallFrame
            placeVC.thirdButton.imageView?.frame.size = bigFrame
            placeVC.thirdButton.setImage(#imageLiteral(resourceName: "firstplaceSection"), for: .normal)
        }
        
        
    }
    
}
