//
//  AppDelegate.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //        let realm = try! Realm()
        //        print("Realm is located at:", realm.configuration.fileURL!)
        HomeViewController.distanceTotal = DateManager.loadDistance(total: true)
        DateManager.loadTodayData()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        UserDefaults(suiteName: "group.footage")?.set(false, forKey: "isTracking")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults(suiteName: "group.footage")?.set(false, forKey: "isTracking")
    }
    
}
