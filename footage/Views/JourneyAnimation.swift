//
//  JourneyAnimation.swift
//  footage
//
//  Created by 녘 on 2020/06/15.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import EFCountingLabel

class JourneyAnimation {
    
    init(journeyVC: JourneyViewController, journeyIndex: Int) {
        self.journeyVC = journeyVC
        self.journeyIndex = journeyIndex
    }
    
    var journeyVC: JourneyViewController = JourneyViewController()
    var journeyIndex: Int = 0
    var date: Int { // 20200604 || 202006 || 2020
        get {
            Int(StatsViewController.journeyArray[journeyIndex].date)!
        }
    }

    func journeyActivate() {
        alphaToOne(object: journeyVC.youText, time: 0.55)
        alphaToOne(object: journeyVC.seeBackText, time: 1.5)
        setNecessaryLabels()
    }
    
    func alphaToOne(object: UIView, time: Double) {
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { (_) in
            object.alpha = 1
        }
    }
    
    func setNecessaryLabels() {
        switch date {
        case ...10000 : // journey for a year
            journeyVC.dayLabel.removeFromSuperview()
            journeyVC.dayText.removeFromSuperview()
            journeyVC.monthLabel.removeFromSuperview()
            journeyVC.monthText.removeFromSuperview()
            journeyVC.yearLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            journeyVC.yearLabel.countFrom(2000, to: CGFloat(date), withDuration: 2)
            alphaToOne(object: journeyVC.yearLabel, time: 0.5)
            
        case 10001...1000000 : // journey for a month
            journeyVC.dayLabel.removeFromSuperview()
            journeyVC.dayText.removeFromSuperview()
            
            addNecessaryZeros(date % 100, label: journeyVC.monthLabel) // get month
            journeyVC.monthLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            journeyVC.monthLabel.countFrom(0, to: CGFloat(date % 100), withDuration: 2)
            alphaToOne(object: journeyVC.monthLabel, time: 0.5)
            
            journeyVC.yearLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            journeyVC.yearLabel.countFrom(2000, to: CGFloat(date / 100), withDuration: 2)
            alphaToOne(object: journeyVC.yearLabel, time: 0.5)
            
        default: // journey for a day
            addNecessaryZeros(date % 100, label: journeyVC.dayLabel) // get day
            journeyVC.dayLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            journeyVC.dayLabel.countFrom(0, to: CGFloat(date % 100), withDuration: 2)
            alphaToOne(object: journeyVC.dayLabel, time: 0.5)
            
            addNecessaryZeros(date / 100 % 100, label: journeyVC.monthLabel) // get month
            journeyVC.monthLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            journeyVC.monthLabel.countFrom(0, to: CGFloat(date / 100 % 100), withDuration: 2)
            alphaToOne(object: journeyVC.monthLabel, time: 0.5)
            
            journeyVC.yearLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            journeyVC.yearLabel.countFrom(0, to: CGFloat(date / 10000 % 100), withDuration: 2)
            alphaToOne(object: journeyVC.yearLabel, time: 0.5)
        }
    }
    
    func addNecessaryZeros(_ date: Int, label: EFCountingLabel) {
        if date < 10 {
            label.setUpdateBlock{ (value, label) in
                label.text = String(format: "0%.f", value)
            }
        }
    }
    
}
