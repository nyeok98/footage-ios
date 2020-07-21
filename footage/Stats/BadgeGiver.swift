//
//  BadgeGiver.swift
//  footage
//
//  Created by 녘 on 2020/07/21.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class BadgeGiver {
    
    static func checkDistance() {
        switch UserDefaults.standard.integer(forKey: "minimumTotalDistance") {
        case 0:
            if HomeViewController.distanceTotal/1000 >= 5 {
                if !LevelManager.checkBadge(badgeName: "total_5") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_5", detail: "지금까지 남긴 발자취가 5km가 넘었어요! 본격적으로 당신의 발자취를 남겨볼까요?"))
                    UserDefaults.standard.setValue(5, forKey: "minimumTotalDistance")
                }
            }
            return
            
        case 5:
            if HomeViewController.distanceTotal/1000 >= 10 {
                if !LevelManager.checkBadge(badgeName: "total_10") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_10", detail: "총 발자취 10km 달성! 이제 발자취를 남기는 게 조금 익숙한 당신이네요."))
                    UserDefaults.standard.setValue(10, forKey: "minimumTotalDistance")
                }
            }
            return
        
        case 10:
            if HomeViewController.distanceTotal/1000 >= 50 {
                if !LevelManager.checkBadge(badgeName: "total_50") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_50", detail: "50km!! 다음 뱃지는 얼마나 예쁘게요. 당신이 세상에 흩뿌린 색깔도 그렇게 아름다울거예요."))
                    UserDefaults.standard.setValue(50, forKey: "minimumTotalDistance")
                }
            }
            return
            
        case 50:
            if HomeViewController.distanceTotal/1000 >= 100 {
                if !LevelManager.checkBadge(badgeName: "total_100") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_100", detail: "지금까지 남긴 발자취가 100km가 넘었습니다. 100은 지금까지를 추억해보기 좋은 숫자예요."))
                    UserDefaults.standard.setValue(100, forKey: "minimumTotalDistance")
                }
            }
            return
            
        case 100:
            if HomeViewController.distanceTotal/1000 >= 200 {
                if !LevelManager.checkBadge(badgeName: "total_200") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_200", detail: "어느새 200km의 발자취를 남긴 당신. 이제 공간이 당신에게 주는 가치는 어느정도 달라지지 않았을까요?"))
                    UserDefaults.standard.setValue(200, forKey: "minimumTotalDistance")
                }
            }
            return
            
        case 200:
            if HomeViewController.distanceTotal/1000 >= 500 {
                if !LevelManager.checkBadge(badgeName: "total_500") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_500", detail: "500km에 이르는 당신의 발자취는 이미 서울과 부산을 넘었네요. 그 안에 담겼을 무수한 당신의 추억은 얼마나 값질까요."))
                    UserDefaults.standard.setValue(500, forKey: "minimumTotalDistance")
                }
            }
            return
            
        case 500:
            if HomeViewController.distanceTotal/1000 >= 1000 {
                if !LevelManager.checkBadge(badgeName: "total_1000") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_1000", detail: "1000km. 더이상 거리 재는건 무의미하네요. 그저 당신이 추억한, 추억할 발걸음이 아름다울 뿐입니다."))
                    UserDefaults.standard.setValue(1000, forKey: "minimumTotalDistance")
                }
            }
            return
        case 1000:
            return
        default:
            return
        }
        
        
        
        
    }
}
