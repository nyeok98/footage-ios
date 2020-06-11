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
    
    //삼각형 원래 위치 화면 비율로 계산한 부분
    static let triangleOriginalPosition = [
        CGPoint(x: screenWidth * 0.63, y: screenHeight * 0.11),
        CGPoint(x: screenWidth * 0.70, y: screenHeight * 0.17),
        CGPoint(x: screenWidth * 0.76, y: screenHeight * 0.05),
        CGPoint(x: screenWidth * 0.86, y: screenHeight * 0.11),
        CGPoint(x: screenWidth * 0.85, y: screenHeight * 0.22)]
    
//MARK- homeStartAnimation
    
    static func homeStartAnimation(_ homeVC: HomeViewController) {
        homeVC.startButton.setImage(#imageLiteral(resourceName: "stop_btn"), for: .normal)
        homeVC.todayString.text = "오늘,"
        homeVC.youString.text = "당신이 새로 남긴"
        
        //home화면 삼각형 사각형으로 바꾸는 부분.
        let images = [homeVC.triangle3, homeVC.triangle1, homeVC.triangle2, homeVC.triangle4, homeVC.triangle5]
        let squares = [homeVC.square1, homeVC.square2, homeVC.square3, homeVC.square4]
        var imageIndex = 0.0
        for image in images {
            Timer.scheduledTimer(withTimeInterval: 0.1 * imageIndex, repeats: false) { (timer) in
                self.shootupwards(image!)
            }
            imageIndex += 1
        }
        imageIndex = 0.0
        for square in squares {
            Timer.scheduledTimer(withTimeInterval: 0.2 * imageIndex, repeats: false) { (timer) in
                squareAppear(square!)
            }
            imageIndex += 1
        }
    }

    //삼각형 올라오도록 하는 함수
    static func shootupwards(_ image: UIImageView) {
        UIView.animate(withDuration: 0.25, animations: {
            var origin = image.frame.origin
            let size = image.frame.size
            origin.y = -40
            image.frame = CGRect(origin: origin, size: size)
        })
    }
    
    //사각형 서서히 나타나게 하는 함수
    static func squareAppear(_ square: UIImageView) {
        UIView.animate(withDuration: 0.25, animations: {
            square.alpha = 1
        })
    }

//MARK- homeStopAnimation
    
    static func homeStopAnimation(_ homeVC: HomeViewController) {
        
        homeVC.startButton.setImage(#imageLiteral(resourceName: "start_btn"), for: .normal)
        homeVC.todayString.text = "오늘까지"
        homeVC.youString.text = "당신이 남긴"
        
        let images = [homeVC.triangle1, homeVC.triangle2, homeVC.triangle3, homeVC.triangle4, homeVC.triangle5]
        let squares = [homeVC.square1, homeVC.square2, homeVC.square3, homeVC.square4]
        for index in 0...4 {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(index), repeats: false) { (timer) in
                self.comebackTriangles(images[index]!, triangleOriginalPosition[index])
            }
        }
        var imageIndex = 0.0
        for square in squares {
            Timer.scheduledTimer(withTimeInterval: 0.1 * imageIndex, repeats: false) { (timer) in
                squareDisappear(square!)
            }
            imageIndex += 1
        }
    }
    
    //삼각형 다시 원래 자리로 내려오게 하는 부분
    static func comebackTriangles (_ image: UIImageView, _ position: CGPoint) {
        UIView.animate(withDuration: 0.25, animations: {
            image.frame = CGRect(origin: position, size: image.frame.size)
        })
    }
    
    //사각형 사라지게 하는 부분
    static func squareDisappear(_ square: UIImageView) {
        UIView.animate(withDuration: 0.25, animations: {
            square.alpha = 0
        })
    }
}
