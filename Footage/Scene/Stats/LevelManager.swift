//
//  LevelManager.swift
//  footage
//
//  Created by 녘 on 2020/07/17.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import Foundation
import RealmSwift

class LevelManager {
    
    static func firstLaunch() {
        let realm = try! Realm()
        do { try realm.write {
            realm.add(Badge(type: "distance", imageName: "starter_level", detail: "처음 시작을 눌러보았어요."))
        }} catch { print(error) }
    }
    
    static func loadTodayBadge(imageName: String) -> Badge? {
        let realm = try! Realm()
        let result = realm.objects(Badge.self).filter("'\(imageName)' == imageName")
        return result.isEmpty ? nil : result[0]
    }
    
    static func loadBadgeList() -> [Badge]? {
        let realm = try! Realm()
        let result = Array(realm.objects(Badge.self))
        return result.isEmpty ? nil : result
    }
    
    static func appendBadge(badge: Badge) {
        let realm = try! Realm()
        do { try realm.write {
            realm.add(badge)
        }} catch { print(error) }
    }
    
    static func checkBadge(badgeName: String) -> Bool {
        let realm = try! Realm()
        let result = realm.objects(Badge.self).filter("'\(badgeName)' == imageName")
        return result.isEmpty ? false : true
    }
    
    static func callMonthlyBadge(month: String) -> [Badge]? {
        let realm = try! Realm()
        let result = Array(realm.objects(Badge.self).filter("date BEGINSWITH '\(month)'"))
        return result.isEmpty ? nil : result
    }
}
