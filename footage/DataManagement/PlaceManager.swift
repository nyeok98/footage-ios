//
//  ColorManager.swift
//  footage
//
//  Created by Wootae on 6/30/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class PlaceManager {

    static var lastLocality = ""
    static var lastData: Place! = nil
    
    static func update(latitude: Double, longitude: Double, distance: Double) {
        let realm = try! Realm()
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), preferredLocale: Locale(identifier: "kr")) { (placemarks, error) in
            let placemark = placemarks![0]
            do { try realm.write {
                if lastLocality == "" || placemark.locality != lastLocality { // first walk of the day or new region
                    let today = DateConverter.dateToDay(date: Date())
                    let result = realm.objects(Place.self)
                        .filter("\(today) == date && '\(placemark.locality ?? "")' == locality")
                    if result.isEmpty {
                        lastData = Place(date: today, placemark: placemark)
                        realm.add(lastData)
                    } else { lastData = result[0] }
                    lastLocality = placemark.locality ?? ""
                }
                lastData.distance += distance
            }} catch { print(error) }
        }
    }
    
    static func getDistance(key: String, value: String, startDate: Int, endDate: Int) -> Double {
        let realm = try! Realm()
        var distance = 0.0
        let result = realm.objects(Place.self).filter("date >= \(startDate) AND date <= \(endDate) AND key == '\(value)'")
        for day in result { distance += day.distance }
        return distance
    }
    
    static func getRankingDistance(startDate: Int, endDate: Int) -> Array<(key: String, value: Double)> {
        // returns [(key: "서울특별시 / 동작구", value: 3.2), (key: "서울특별시 / 강남구", value: 2.2) ... ]
        var rank: [String: Double] = [:]
        let realm = try! Realm()
        let results = realm.objects(Place.self).filter("date >= \(startDate) AND date <= \(endDate)")
        for result in results {
            var key = result.administrativeArea + " / " + result.locality
            if result.administrativeArea == "세종특별자치시" { //  세종시 예외처리
                key = result.administrativeArea + " / " + result.subLocality
            }
            if rank.keys.contains(key) {
                rank[key]! += result.distance
            } else {
                rank[key] = result.distance
            }
        }
        return rank.sorted(by: {$0.value > $1.value})
    }

}
