//
//  BadgeGiver.swift
//  footage
//
//  Created by 녘 on 2020/07/21.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class BadgeGiver {
    
    static func checkDistance(view: UIView) {
        switch UserDefaults.standard.integer(forKey: "minimumTotalDistance") {
        case 0:
            if HomeViewController.distanceTotal/1000 >= 5 {
                if !LevelManager.checkBadge(badgeName: "total_5") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_5", detail: "지금까지 남긴 발자취가 5km가 넘었어요! 본격적으로 당신의 발자취를 남겨볼까요?"))
                    UserDefaults.standard.setValue(5, forKey: "minimumTotalDistance")
                    gotBadge(view: view, badge: Badge(type: "distance", imageName: "total_5", detail: "지금까지 남긴 발자취가 5km가 넘었어요! 본격적으로 당신의 발자취를 남겨볼까요?"))
                }
            }
            return
            
        case 5:
            if HomeViewController.distanceTotal/1000 >= 10 {
                if !LevelManager.checkBadge(badgeName: "total_10") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_10", detail: "총 발자취 10km 달성! 이제 발자취를 남기는 게 조금 익숙한 당신이네요."))
                    UserDefaults.standard.setValue(10, forKey: "minimumTotalDistance")
                    gotBadge(view: view, badge: Badge(type: "distance", imageName: "total_10", detail: "총 발자취 10km 달성! 이제 발자취를 남기는 게 조금 익숙한 당신이네요."))
                }
            }
            return
        
        case 10:
            if HomeViewController.distanceTotal/1000 >= 50 {
                if !LevelManager.checkBadge(badgeName: "total_50") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_50", detail: "50km!! 다음 뱃지는 얼마나 예쁘게요. 당신이 세상에 흩뿌린 색깔도 그렇게 아름다울거예요."))
                    UserDefaults.standard.setValue(50, forKey: "minimumTotalDistance")
                    gotBadge(view: view, badge: Badge(type: "distance", imageName: "total_50", detail: "50km!! 다음 뱃지는 얼마나 예쁘게요. 당신이 세상에 흩뿌린 색깔도 그렇게 아름다울거예요."))
                }
            }
            return
            
        case 50:
            if HomeViewController.distanceTotal/1000 >= 100 {
                if !LevelManager.checkBadge(badgeName: "total_100") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_100", detail: "지금까지 남긴 발자취가 100km가 넘었습니다. 100은 지금까지를 추억해보기 좋은 숫자예요."))
                    UserDefaults.standard.setValue(100, forKey: "minimumTotalDistance")
                    gotBadge(view: view, badge: Badge(type: "distance", imageName: "total_100", detail: "지금까지 남긴 발자취가 100km가 넘었습니다. 100은 지금까지를 추억해보기 좋은 숫자예요."))
                }
            }
            return
            
        case 100:
            if HomeViewController.distanceTotal/1000 >= 200 {
                if !LevelManager.checkBadge(badgeName: "total_200") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_200", detail: "어느새 200km의 발자취를 남긴 당신. 이제 공간이 당신에게 주는 가치는 어느정도 달라지지 않았을까요?"))
                    UserDefaults.standard.setValue(200, forKey: "minimumTotalDistance")
                    gotBadge(view: view, badge: Badge(type: "distance", imageName: "total_200", detail: "어느새 200km의 발자취를 남긴 당신. 이제 공간이 당신에게 주는 가치는 어느정도 달라지지 않았을까요?"))
                }
            }
            return
            
        case 200:
            if HomeViewController.distanceTotal/1000 >= 500 {
                if !LevelManager.checkBadge(badgeName: "total_500") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_500", detail: "500km에 이르는 당신의 발자취는 이미 서울과 부산을 넘었네요. 그 안에 담겼을 무수한 당신의 추억은 얼마나 값질까요."))
                    UserDefaults.standard.setValue(500, forKey: "minimumTotalDistance")
                    gotBadge(view: view, badge: Badge(type: "distance", imageName: "total_500", detail: "500km에 이르는 당신의 발자취는 이미 서울과 부산을 넘었네요. 그 안에 담겼을 무수한 당신의 추억은 얼마나 값질까요."))
                }
            }
            return
            
        case 500:
            if HomeViewController.distanceTotal/1000 >= 1000 {
                if !LevelManager.checkBadge(badgeName: "total_1000") {
                    LevelManager.appendBadge(badge: Badge(type: "distance", imageName: "total_1000", detail: "1000km. 더이상 거리 재는건 무의미하네요. 그저 당신이 추억한, 추억할 발걸음이 아름다울 뿐입니다."))
                    UserDefaults.standard.setValue(1000, forKey: "minimumTotalDistance")
                    gotBadge(view: view, badge: Badge(type: "distance", imageName: "total_1000", detail: "1000km. 더이상 거리 재는건 무의미하네요. 그저 당신이 추억한, 추억할 발걸음이 아름다울 뿐입니다."))
                }
            }
            return
        case 1000:
            return
        default:
            return
        }
        
        
        
        
    }
    
    static func cityCheck(view: UIView) {
        switch PlaceManager.currentAdministrativeArea {
        case Korea.jeju.cityName() :
            if PlaceManager.localityList?.count == 1 && PlaceManager.isAppended == true  {
                LevelManager.appendBadge(badge: Badge(type: "place", imageName: "Jeju_newb", detail: "제주가 조금 익숙해지기 시작하셨군요!"))
                LevelManager.appendBadge(badge: Badge(type: "place", imageName: "Jeju_junior", detail: "제주의 반을 본 셈이에요!"))
                gotBadge(view: view, badge: Badge(type: "place", imageName: "Jeju_junior", detail: "제주의 반을 본 셈이에요!"))
            }
            if PlaceManager.localityList?.count == 2 && PlaceManager.isAppended == true {
                LevelManager.appendBadge(badge: Badge(type: "place", imageName: "Jeju_master", detail: "제주의 모든 행정구역을 만나보았어요!\n제주, 이제 당신의 발자취로 가득합니다."))
                gotBadge(view: view, badge: Badge(type: "place", imageName: "Jeju_master", detail: "제주의 모든 행정구역을 만나보았어요!\n제주, 이제 당신의 발자취로 가득합니다."))
            }
        case Korea.sejong.cityName() :
            placeBadgeCreator(cityName: Korea.sejong, view: view)
        case Korea.seoul.cityName() :
            placeBadgeCreator(cityName: Korea.seoul, view: view)
        case Korea.incheon.cityName() :
            placeBadgeCreator(cityName: Korea.incheon, view: view)
        case Korea.busan.cityName() :
            placeBadgeCreator(cityName: Korea.busan, view: view)
        case Korea.daegu.cityName() :
            placeBadgeCreator(cityName: Korea.daegu, view: view)
        case Korea.gwangju.cityName() :
            placeBadgeCreator(cityName: Korea.gwangju, view: view)
        case Korea.daejeon.cityName() :
            placeBadgeCreator(cityName: Korea.daejeon, view: view)
        case Korea.ulsan.cityName() :
            placeBadgeCreator(cityName: Korea.ulsan, view: view)
        case Korea.gyeonggi.cityName() :
            placeBadgeCreator(cityName: Korea.gyeonggi, view: view)
        case Korea.gangwon.cityName() :
            placeBadgeCreator(cityName: Korea.gangwon, view: view)
        case Korea.northJeolla.cityName() :
            placeBadgeCreator(cityName: Korea.northJeolla, view: view)
        case Korea.southJeolla.cityName() :
            placeBadgeCreator(cityName: Korea.southJeolla, view: view)
        case Korea.northChungcheong.cityName() :
            placeBadgeCreator(cityName: Korea.northChungcheong, view: view)
        case Korea.southChungcheong.cityName() :
            placeBadgeCreator(cityName: Korea.southChungcheong, view: view)
        case Korea.northGyeongsang.cityName() :
            placeBadgeCreator(cityName: Korea.northGyeongsang, view: view)
        case Korea.southGyeongsang.cityName() :
            placeBadgeCreator(cityName: Korea.southGyeongsang, view: view)
            
        //california for test
        case Korea.california.cityName() :
            if PlaceManager.localityList?.count == 2 && PlaceManager.isAppended == true {
                LevelManager.appendBadge(badge: Badge(type: "place", imageName: "Sejong City_newb", detail: "이 지역에 이제 막 발자취를 남기기 시작했습니다."))
                BadgeGiver.gotBadge(view: view, badge: Badge(type: "place", imageName: "Sejong City_newb", detail: "이 지역에 이제 막 발자취를 남기기 시작했습니다."))
                PlaceManager.isAppended = false
            }
            if PlaceManager.localityList?.count == Int(ceil(Korea.california.numberOfLocality()/2))  && PlaceManager.isAppended == true {
                LevelManager.appendBadge(badge: Badge(type: "place", imageName: "Sejong City_junior", detail: "이 지역 행정구역의 반에 발자취를 남겼습니다!"))
                BadgeGiver.gotBadge(view: view, badge: Badge(type: "place", imageName: "Sejong City_junior", detail: "이 지역 행정구역의 반에 발자취를 남겼습니다!"))
                PlaceManager.isAppended = false
            }
            if PlaceManager.localityList?.count == Int(Korea.california.numberOfLocality())  && PlaceManager.isAppended == true {
                LevelManager.appendBadge(badge: Badge(type: "place", imageName: "Sejong City_master", detail: "이 지역의 모든 행정구역을 만나보았어요!\n이 지역은 당신의 발자취로 가득합니다."))
                BadgeGiver.gotBadge(view: view, badge: Badge(type: "place", imageName: "Sejong City_master", detail: "이 지역의 모든 행정구역을 만나보았어요!\n이 지역은 당신의 발자취로 가득합니다."))
                PlaceManager.isAppended = false
            }
        default:
            placeBadgeCreator(cityName: Korea.sejong, view: view)
        }
    }
    
    static func gotBadge(view: UIView, badge: Badge) {
        noti_gotBadge()
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let popupcard = PopUpCard()
        popupcard.badgeImageView.image = UIImage(named: badge.imageName)
        view.addSubview(popupcard)
        view.bringSubviewToFront(popupcard)
        popupcard.frame = CGRect.init(x: 0, y: 0, width: screenWidth*1.2, height: screenHeight*1.2)
        popupcard.backgroundColor = UIColor.clear     //give color to the view
        popupcard.center = view.center
        popupcard.badgeImageView.doGlowAnimation(withColor: UIColor.yellow)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            UIView.animate(withDuration: 1) {
                popupcard.badgeImageView.frame.origin.y += 20
            }
            UIView.animate(withDuration: 0.5) {
                popupcard.badgeImageView.frame.origin.y -= 20
            }
        }
    }
    
    static func placeBadgeCreator(cityName: Korea, view: UIView) {
        if PlaceManager.localityList?.count == 2 && PlaceManager.isAppended == true {
            LevelManager.appendBadge(badge: Badge(type: "place", imageName: "\(cityName.cityName())_newb", detail: "이 지역에 이제 막 발자취를 남기기 시작했습니다."))
            BadgeGiver.gotBadge(view: view, badge: Badge(type: "place", imageName: "\(cityName.cityName())_newb", detail: "이 지역에 이제 막 발자취를 남기기 시작했습니다."))
            PlaceManager.isAppended = false
        }
        if PlaceManager.localityList?.count == Int(round(Double(cityName.numberOfLocality()/2)))  && PlaceManager.isAppended == true {
            LevelManager.appendBadge(badge: Badge(type: "place", imageName: "\(cityName.cityName())_junior", detail: "이 지역 행정구역의 반에 발자취를 남겼습니다!"))
            BadgeGiver.gotBadge(view: view, badge: Badge(type: "place", imageName: "\(cityName.cityName())_junior", detail: "이 지역 행정구역의 반에 발자취를 남겼습니다!"))
            PlaceManager.isAppended = false
        }
        if PlaceManager.localityList?.count == Int(cityName.numberOfLocality())  && PlaceManager.isAppended == true {
            LevelManager.appendBadge(badge: Badge(type: "place", imageName: "\(cityName.cityName())_master", detail: "이 지역의 모든 행정구역을 만나보았어요!\n이 지역은 당신의 발자취로 가득합니다."))
            BadgeGiver.gotBadge(view: view, badge: Badge(type: "place", imageName: "\(cityName.cityName())_master", detail: "이 지역의 모든 행정구역을 만나보았어요!\n이 지역은 당신의 발자취로 가득합니다."))
            PlaceManager.isAppended = false
        }
    }
    
    static func noti_gotBadge() {
        if UserDefaults.standard.bool(forKey: "wantPush") {
            let content = UNMutableNotificationContent()
            content.title = "새로운 뱃지를 획득하였습니다!"
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let randomIdentifier = UUID().uuidString
            let request = UNNotificationRequest(identifier: randomIdentifier, content: content, trigger: trigger)

            // 3
            UNUserNotificationCenter.current().add(request) { error in
              if error != nil {
                print("something went wrong")
              }
            }
        }
    }
}

extension UIView {
    enum GlowEffect: Float {
        case small = 0.4, normal = 2, big = 30
    }

    func doGlowAnimation(withColor color: UIColor, withEffect effect: GlowEffect = .big) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 30
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero

        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = effect.rawValue
        glowAnimation.fillMode = .removed
        glowAnimation.repeatCount = .infinity
        glowAnimation.duration = 0.5
        glowAnimation.autoreverses = true
        layer.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
}
