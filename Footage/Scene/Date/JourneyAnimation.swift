//
//  JourneyAnimation.swift
//  footage
//
//  Created by 녘 on 2020/06/15.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit
import EFCountingLabel

extension JourneyViewController {
    
    var date: Int { // 20200604 || 202006 || 2020
        get {
            Int(journeyManager.journey.date)
        }
    }
    
    func alphaToOne(object: UIView, time: Double) {
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { (_) in
            object.alpha = 1
        }
    }
    
    func animateDateLabel() {
        switch date {
        case ...10000 : // journey for a year
            dayLabel.removeFromSuperview()
            dayText.removeFromSuperview()
            monthLabel.removeFromSuperview()
            monthText.removeFromSuperview()
            yearLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            yearLabel.countFrom(2000, to: CGFloat(date), withDuration: 2)
            alphaToOne(object: yearLabel, time: 0.5)
            
        case 10001...1000000 : // journey for a month
            dayLabel.removeFromSuperview()
            dayText.removeFromSuperview()
            
            addNecessaryZeros(date % 100, label: monthLabel) // get month
            monthLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            monthLabel.countFrom(0, to: CGFloat(date % 100), withDuration: 2)
            alphaToOne(object: monthLabel, time: 0.5)
            
            yearLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            yearLabel.countFrom(2000, to: CGFloat(date / 100), withDuration: 2)
            alphaToOne(object: yearLabel, time: 0.5)
            
        default: // journey for a day
            addNecessaryZeros(date % 100, label: dayLabel) // get day
            dayLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            dayLabel.countFrom(0, to: CGFloat(date % 100), withDuration: 2)
            alphaToOne(object: dayLabel, time: 0.5)
            
            addNecessaryZeros(date / 100 % 100, label: monthLabel) // get month
            monthLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            monthLabel.countFrom(0, to: CGFloat(date / 100 % 100), withDuration: 2)
            alphaToOne(object: monthLabel, time: 0.5)
            
            yearLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            yearLabel.countFrom(0, to: CGFloat(date / 10000 % 100), withDuration: 2)
            alphaToOne(object: yearLabel, time: 0.5)
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
