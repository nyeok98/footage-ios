//
//  HomeAnimation.swift
//  footage
//
//  Created by 녘 on 2020/06/11.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit


class HomeAnimation {
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let triangleOriginalPosition = [
        CGPoint(x: screenWidth * 0.63, y: screenHeight * 0.11),
        CGPoint(x: screenWidth * 0.70, y: screenHeight * 0.17),
        CGPoint(x: screenWidth * 0.76, y: screenHeight * 0.05),
        CGPoint(x: screenWidth * 0.86, y: screenHeight * 0.11),
        CGPoint(x: screenWidth * 0.85, y: screenHeight * 0.22)]
    
    static func homeStartAnimation(_ homeVC: HomeViewController) {
        homeVC.startButton.setImage(#imageLiteral(resourceName: "stop_btn"), for: .normal)
        homeVC.todayString.text = "오늘"
        homeVC.youString.text = "당신이 새로 남긴"
        homeVC.footString.text = "발자취"
        homeVC.todayString.alpha = 0.0
        homeVC.youString.alpha = 0.0
        homeVC.footString.alpha = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.todayString.alpha = 1
            })
        }
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.youString.alpha = 1
            })
        }
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.footString.alpha = 1
            })
        }
    
      // home화면 삼각형 사각형으로 바꾸는 부분.
        let images = [homeVC.triangle3, homeVC.triangle1, homeVC.triangle2, homeVC.triangle4, homeVC.triangle5]
        var imageIndex = 0.0
        for image in images {
            Timer.scheduledTimer(withTimeInterval: 0.1 * imageIndex, repeats: false) { (timer) in
                self.shootupwards(image!)
            }
            imageIndex += 1
        }
    }
    
    static func shootupwards(_ image: UIImageView) {
        UIView.animate(withDuration: 0.25, animations: {
            var origin = image.frame.origin
            let size = image.frame.size
            origin.y = -40
            image.frame = CGRect(origin: origin, size: size)
        })
    }

    static func homeStopAnimation(_ homeVC: HomeViewController) {
        
        homeVC.startButton.setImage(#imageLiteral(resourceName: "start_btn"), for: .normal)
        homeVC.todayString.text = "오늘까지"
        homeVC.youString.text = "당신이 남긴"
        homeVC.footString.text = "발자취"
        homeVC.todayString.alpha = 0.0
        homeVC.youString.alpha = 0.0
        homeVC.footString.alpha = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.todayString.alpha = 1
            })
        }
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.youString.alpha = 1
            })
        }
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.footString.alpha = 1
            })
        }
        
        let images = [homeVC.triangle1, homeVC.triangle2, homeVC.triangle3, homeVC.triangle4, homeVC.triangle5]
        for index in 0...4 {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(index), repeats: false) { (timer) in
                self.comebackTriangles(images[index]!, triangleOriginalPosition[index])
            }
        }
    }
    
    static func comebackTriangles (_ image: UIImageView, _ position: CGPoint) {
        UIView.animate(withDuration: 0.25, animations: {
            image.frame = CGRect(origin: position, size: image.frame.size)
        })
    }
}
