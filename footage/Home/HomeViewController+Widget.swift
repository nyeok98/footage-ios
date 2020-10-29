//
//  HomeViewController+Widget.swift
//  footage
//
//  Created by Wootae on 10/10/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import MapKit

extension HomeViewController {
    func saveDataForWidget() {
        
        let mapSnapshotOptions = MKMapSnapshotter.Options
        mapSnapshotOptions.region = mapView.region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = mapView.frame.size
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true

        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snap, error) in
            let image = snap?.image
            imageView.image = image
        }
        
//        let renderer = UIGraphicsImageRenderer(size: mainMap.bounds.size)
//        let image = renderer.image { ctx in
//            mainMap.drawHierarchy(in: mainMap.bounds, afterScreenUpdates: true)
//        }
//        if var directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.footage") {
//            directory.appendPathComponent("db.realm", isDirectory: true)
//            let config = Realm.Configuration(fileURL: directory, schemaVersion: 1)
//            Realm.Configuration.defaultConfiguration = config
//        }
//        let realm = try! Realm()
//        do { try realm.write {
//            let result = realm.objects(WidgetRealm.self)
//            if result.isEmpty {
//                realm.add(WidgetRealm(isTracking: false, snapshot: image.jpegData(compressionQuality: 1.0)!))
//            } else {
//                result[0].snapshot = image.jpegData(compressionQuality: 1.0)!
//                result[0].isTracking = true
//            }
//            let final = realm.objects(WidgetRealm.self)
//            print(image.jpegData(compressionQuality: 1.0)!)
//            print(final[0].snapshot)
//            print(final[0].isTracking)
//            view.addSubview(UIImageView(image: UIImage(data: image.pngData()!)))
//            view.addSubview(UIImageView(image: UIImage(data: final[0].snapshot)))
//        }} catch { print(error) }
//        guard let userDefaults = UserDefaults(suiteName: "group.footage") else { return }
//        userDefaults.set(image.pngData(), forKey: "snapshot")
//        userDefaults.set(startButton.currentImage == #imageLiteral(resourceName: "stopButton"), forKey: "isTracking")
    }
}

