//
//  SceneDelegate.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let homeVC = HomeViewController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
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
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        //UserDefaults.standard.setValue(HomeViewController.selectedColor, forKey: "lastColor")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        let userState = UserDefaults.standard.string(forKey: "UserState")
        if userState == "hasPassword" || userState == "hasBioId"  {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
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
        } else if userState == nil { // first launch
            UserDefaults.standard.set("", forKey: "todayBadge")
            UserDefaults.standard.set(0, forKey: "minimumTotalDistance")
            UserDefaults.standard.set(0, forKey: "minimumTotalRecord")
            UserDefaults.standard.set(false, forKey: "startedBefore")
            UserDefaults.standard.set("노란색", forKey: "#EADE4Cff")
            UserDefaults.standard.set("분홍색", forKey: "#F5A997ff")
            UserDefaults.standard.set("흰  색", forKey: "#F0E7CFff")
            UserDefaults.standard.set("주황색", forKey: "#FF6B39ff")
            UserDefaults.standard.set("파란색", forKey: "#206491ff")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let firstLaunchVC = storyBoard.instantiateViewController(withIdentifier: "FL_VideoVC") as! FL_VideoVC
            self.window?.rootViewController = firstLaunchVC
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        if HomeViewController.currentStartButtonImage == #imageLiteral(resourceName: "stopButton") {
            HomeViewController.locationManager.startUpdatingLocation()
        }
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
