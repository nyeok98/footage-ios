//
//  HomeAnimation.swift
//  footage
//
//  Created by 녘 on 2020/06/11.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import EFCountingLabel


class HomeAnimation {
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    
    //삼각형 원래 위치 화면 비율로 계산한 부분
    static let triangleOriginalPosition = [
        CGPoint(x: screenWidth * 0.63, y: screenHeight * 0.11),
        CGPoint(x: screenWidth * 0.70, y: screenHeight * 0.17),
        CGPoint(x: screenWidth * 0.76, y: screenHeight * 0.05),
        CGPoint(x: screenWidth * 0.86, y: screenHeight * 0.11),
        CGPoint(x: screenWidth * 0.85, y: screenHeight * 0.22)]
    
//MARK- homeStartAnimation
    
    static func homeStartAnimation(_ homeVC: HomeViewController) {
        // start button pressed
        
        
        UIView.animate(withDuration: 1, animations: {
            homeVC.startButton.alpha = 0
        })
        UIView.animate(withDuration: 2, animations: {
            homeVC.startButton.alpha = 1
        })
        UIView.animate(withDuration: 1, animations: {
            homeVC.startButton.setImage(#imageLiteral(resourceName: "stop_btn"), for: .normal)
        })
        UIView.animate(withDuration: 1) {
            homeVC.mainMap.alpha = 0
        }
        
        // 0. Counting Rate
        homeVC.distanceView.alpha = 0
        UIView.animate(withDuration: 3.5, animations: {
            homeVC.distanceView.alpha = 1
        })
        homeVC.unitLabel.alpha = 0
        UIView.animate(withDuration: 3, animations: {
            homeVC.unitLabel.alpha = 1
        })
        homeVC.distance.setUpdateBlock { (value, label) in
            label.text = String(format: "%.2f", value)
        }
        homeVC.distance.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 7)
        homeVC.distance.countFrom(0, to: CGFloat(HomeViewController.distanceToday / 1000), withDuration: 5)
        
        // 1. Text Animation
        
        homeVC.todayString.text = "오늘"
        homeVC.youString.text = "당신이 새로 남긴"
        homeVC.footString.text = "발자취"
        homeVC.todayString.alpha = 0.0
        homeVC.youString.alpha = 0.0
        homeVC.footString.alpha = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.todayString.alpha = 1
            })
        }
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.youString.alpha = 1
            })
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.footString.alpha = 1
            })
        }
        // Text Animation Ends
        
        // 2. Triangle Disappear
        let images = [homeVC.triangle3, homeVC.triangle1, homeVC.triangle2, homeVC.triangle4, homeVC.triangle5]
        var imageIndex = 0.0
        for image in images {
            Timer.scheduledTimer(withTimeInterval: 0.1 * imageIndex, repeats: false) { (timer) in
                self.shootupwards(image!)
            }
            imageIndex += 1
        }
        // 2
        
        // 3. Square Appear
        let squares = [homeVC.square1, homeVC.square2, homeVC.square3, homeVC.square4]
        imageIndex = 0.0
        for square in squares {
            Timer.scheduledTimer(withTimeInterval: 0.6 + (0.2 * imageIndex), repeats: false) { (timer) in
                squareAppear(square!)
            }
            imageIndex += 1
        }
        // 3
    }

    // 삼각형 없어지도록 하는 함수
    static func shootupwards(_ image: UIImageView) {
        UIView.animate(withDuration: 0.25, animations: {
            var origin = image.frame.origin
            let size = image.frame.size
            origin.y = -40
            image.frame = CGRect(origin: origin, size: size)
        })
    }
    
    // 사각형 서서히 나타나게 하는 함수
    static func squareAppear(_ square: UIImageView) {
        UIView.animate(withDuration: 0.25, animations: {
            square.alpha = 1
        })
    }

//MARK- homeStopAnimation
    
    static func homeStopAnimation(_ homeVC: HomeViewController) {
        
        UIView.animate(withDuration: 1, animations: {
            homeVC.startButton.alpha = 0
        })
        UIView.animate(withDuration: 2, animations: {
            homeVC.startButton.alpha = 1
        })
        UIView.animate(withDuration: 1, animations: {
            homeVC.startButton.setImage(#imageLiteral(resourceName: "start_btn"), for: .normal)
        })
        UIView.animate(withDuration: 1) {
            homeVC.mainMap.alpha = 0
        }
        
        // 0. Counting Rate
        homeVC.distanceView.alpha = 0
        UIView.animate(withDuration: 3.5, animations: {
            homeVC.distanceView.alpha = 1
        })
        homeVC.unitLabel.alpha = 0
        UIView.animate(withDuration: 3, animations: {
            homeVC.unitLabel.alpha = 1
        })
        homeVC.distance.setUpdateBlock { (value, label) in
            label.text = String(format: "%.f", value)
        }
        homeVC.distance.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 7)
        homeVC.distance.countFrom(0, to: 136, withDuration: 5)
        
        // 1. Text Animation
        homeVC.todayString.text = "오늘까지"
        homeVC.youString.text = "당신이 남긴"
        homeVC.footString.text = "발자취"
        homeVC.todayString.alpha = 0.0
        homeVC.youString.alpha = 0.0
        homeVC.footString.alpha = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.todayString.alpha = 1
            })
        }
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.youString.alpha = 1
            })
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                homeVC.footString.alpha = 1
            })
        }
        // 1
        
        // 2. Square Disappear
        
        let squares = [homeVC.square1, homeVC.square2, homeVC.square3, homeVC.square4]
        var imageIndex = 0.0
        for square in squares {
            Timer.scheduledTimer(withTimeInterval: 0.1 * imageIndex, repeats: false) { (timer) in
                squareDisappear(square!)
            }
            imageIndex += 1
        }
        // 2
        
        // 3. Triangle Appear
        let images = [homeVC.triangle1, homeVC.triangle2, homeVC.triangle3, homeVC.triangle4, homeVC.triangle5]
        
        for index in 0...4 {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(index) + 0.5, repeats: false) { (timer) in
                self.comebackTriangles(images[index]!, triangleOriginalPosition[index])
            }
        }
    }
    
    //삼각형 다시 원래 자리로 내려오게 하는 부분
    static func comebackTriangles (_ image: UIImageView, _ position: CGPoint) {
        UIView.animate(withDuration: 0.25, animations: {
            image.frame = CGRect(origin: position, size: image.frame.size)
            image.alpha = 1
        })
    }
    
    //사각형 사라지게 하는 부분
    static func squareDisappear(_ square: UIImageView) {
        UIView.animate(withDuration: 0.25, animations: {
            square.alpha = 0
        })
    }
}
