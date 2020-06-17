//
//  JourneyAnimation.swift
//  footage
//
//  Created by 녘 on 2020/06/17.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import EFCountingLabel


class JourneyAnimation {

    static func journeyActivate(_ journeyVC: JourneyViewController) {
        
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                journeyVC.yearLabel.alpha = 1
            })
        }

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                journeyVC.monthLabel.alpha = 1
            })
        }

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                journeyVC.dayLabel.alpha = 1
            })
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                journeyVC.youLabel.alpha = 1
            })
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            UIView.animate(withDuration: 1, animations: {
                journeyVC.seeBackLabel.alpha = 1
            })
        }
        
        journeyVC.yearLabel.setUpdateBlock { (value, label) in
            label.text = String(format: "%.f", value)
        }
        
        if journeyVC.monthLabel.text! < "10" {
            journeyVC.monthLabel.setUpdateBlock{ (value, label) in
                label.text = String(format: "0%.f", value)
            }
        } else {
            journeyVC.monthLabel.setUpdateBlock{ (value, label) in
            label.text = String(format: "%.f", value)
            }
        }
        if journeyVC.dayLabel.text! < "10" {
            
            journeyVC.dayLabel.setUpdateBlock { (value, label) in
                label.text = String(format: "0%.f", value)
            }
        } else {
            journeyVC.dayLabel.setUpdateBlock { (value, label) in
                label.text = String(format: "%.f", value)
            }
        }
        
        journeyVC.yearLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 7)
        journeyVC.yearLabel.countFrom(0, to: 20, withDuration: 5)
        
        journeyVC.monthLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 7)
        journeyVC.monthLabel.countFrom(0, to: 6, withDuration: 5)
        
        journeyVC.dayLabel.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 7)
        journeyVC.dayLabel.countFrom(0, to: 09, withDuration: 5)
        
    }
}
