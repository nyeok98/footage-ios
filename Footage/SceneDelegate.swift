//
//  SceneDelegate.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let homeVC = HomeViewController()
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // TODO: started before 추가
        guard let userDefault = UserDefaults(suiteName: "group.footage") else { return }
        let wasTracking = userDefault.bool(forKey: "isTracking")
        userDefault.set(!wasTracking, forKey: "isTracking")
        if let tabBarVC = window?.rootViewController as? UITabBarController {
            tabBarVC.selectedIndex = 0
            if let homeVC = tabBarVC.selectedViewController as? HomeViewController {
                if !wasTracking {
                    homeVC.startTracking()
                } else {
                    homeVC.stopTracking()
                }
            }
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        let userState = UserDefaults.standard.string(forKey: "UserState")
        if userState == "hasPassword" || userState == "hasBioId"  {
            presentPasswordViewController()
        } else if userState == nil { // first launch
            setInitialUserDefaults()
            presentFirstLaunchViewController()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        if HomeViewController.currentStartButtonImage == #imageLiteral(resourceName: "stopButton") {
            HomeViewController.locationManager.startUpdatingLocation()
        }
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    private func presentPasswordViewController() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let passwordVC = storyBoard.instantiateViewController(withIdentifier: "PasswordVC") as! PasswordVC
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let screenSize = UIScreen.main.bounds
            passwordVC.view.translatesAutoresizingMaskIntoConstraints = false
            passwordVC.view.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
            passwordVC.view.heightAnchor.constraint(equalToConstant: screenSize.height).isActive = true
            passwordVC.modalPresentationStyle = .fullScreen
            topController.present(passwordVC, animated: true, completion: nil)
        }
    }
    
    private func setInitialUserDefaults() {
        UserDefaults.standard.set("", forKey: "todayBadge")
        UserDefaults.standard.set(0, forKey: "minimumTotalDistance")
        UserDefaults.standard.set(0, forKey: "minimumTotalRecord")
        UserDefaults.standard.set(false, forKey: "startedBefore")
        UserDefaults.standard.set("노란색", forKey: "#EADE4Cff")
        UserDefaults.standard.set("분홍색", forKey: "#F5A997ff")
        UserDefaults.standard.set("흰  색", forKey: "#F0E7CFff")
        UserDefaults.standard.set("주황색", forKey: "#FF6B39ff")
        UserDefaults.standard.set("파란색", forKey: "#206491ff")
    }
    
    private func presentFirstLaunchViewController() {
        let storyBoard = UIStoryboard(name: "FirstLaunch", bundle: nil)
        let firstLaunchVC = storyBoard.instantiateViewController(withIdentifier: "FL_VideoVC") as! FL_VideoVC
        self.window?.rootViewController = firstLaunchVC
    }
}
