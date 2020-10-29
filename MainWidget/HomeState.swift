//
//  WidgetView.swift
//  footage
//
//  Created by Wootae on 10/11/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import RealmSwift

struct HomeState {
    var snapshot: UIImage
    var isTracking: Bool
    
    static func create() -> HomeState {
        var snapshot = #imageLiteral(resourceName: "noDataImage")
        var isTracking = false
        guard let userDefaults = UserDefaults(suiteName: "group.footage")
        else { return HomeState(snapshot: snapshot, isTracking: isTracking) }
        isTracking = userDefaults.bool(forKey: "isTracking")
        if let data = userDefaults.data(forKey: "snapshot") {
            print("data available")
            if let image = UIImage(data: data) {
                snapshot = image
            }
        }
        return HomeState(snapshot: snapshot, isTracking: isTracking)
        
        //        let realm = try! Realm()
        //        do { try realm.write {
        //            let result = realm.objects(WidgetRealm.self)
        //            if result.isEmpty {
        //                print("isEmpty")
        //                realm.add(WidgetRealm(isTracking: false, snapshot: snapshot.pngData()!))
        //            }
        //            snapshot = UIImage(data: result[0].snapshot)!
        //            print(snapshot)
        //            isTracking = result[0].isTracking
        //        }} catch { print(error) }
        //        return HomeState(snapshot: snapshot, isTracking: isTracking)
        
    }
}
