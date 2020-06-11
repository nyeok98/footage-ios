//
//  HomeAnimation.swift
//  footage
//
//  Created by 녘 on 2020/06/11.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

let homeVC = HomeViewController()

class HomeAnimation {
    func homeStartAnimation() {
        homeVC.startButton.setImage(#imageLiteral(resourceName: "stop_btn"), for: .normal)
        homeVC.todayString.text = "오늘,"
        homeVC.youString.text = "당신이 새로 남긴"
        //home화면 삼각형 사각형으로 바꾸는 부분.
        UIView.transition(with: homeVC.triangle1,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { homeVC.triangle1.image = UIImage(named: "square1") },
                          completion: nil)
        UIView.transition(with: homeVC.triangle2,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { homeVC.triangle2.image = UIImage(named: "square2") },
                          completion: nil)
        UIView.transition(with: homeVC.triangle3,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { homeVC.triangle3.image = UIImage(named: "square3") },
                          completion: nil)
        UIView.transition(with: homeVC.triangle4,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { homeVC.triangle4.image = UIImage(named: "square4") },
                          completion: nil)
        UIView.transition(with: homeVC.triangle5,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { homeVC.triangle5.image = UIImage(named: "square2") },
                          completion: nil)
    }

    func homeStopAnimation() {
        homeVC.startButton.setImage(#imageLiteral(resourceName: "start_btn"), for: .normal)
        homeVC.todayString.text = "오늘까지"
        homeVC.youString.text = "당신이 남긴"
        UIView.transition(with: homeVC.triangle1,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { homeVC.triangle1.image = UIImage(named: "triangle") },
                          completion: nil)
        UIView.transition(with: homeVC.triangle2,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { homeVC.triangle2.image = UIImage(named: "triangle-1") },
                          completion: nil)
        UIView.transition(with: homeVC.triangle3,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { homeVC.triangle3.image = UIImage(named: "triangle-2") },
                          completion: nil)
        UIView.transition(with: homeVC.triangle4,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { homeVC.triangle4.image = UIImage(named: "triangle-3") },
                          completion: nil)
        UIView.transition(with: homeVC.triangle5,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { homeVC.triangle5.image = UIImage(named: "triangle-4") },
                          completion: nil)
    }
}
