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
    static var localityList: [String]?
    static var currentAdministrativeArea: String = ""
    static var isAppended: Bool = false
    static var lastAdministrativeArea: String = ""
    static var needToLoadData = true
    
    static func update(latitude: Double, longitude: Double, distance: Double) {
        let realm = try! Realm()
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), preferredLocale: Locale(identifier: "ko_KR")) { (placemarks, error) in
            if let placemark = placemarks?[0] {
            do { try realm.write {
                if lastLocality == "" || placemark.locality != lastLocality { // first walk of the day or new region
                    isAppended = false
                    let today = DateConverter.dateToDay(date: Date())
                    let result = realm.objects(Place.self)
                        .filter("\(today) == date && '\(placemark.locality ?? "")' == locality")
                    if result.isEmpty {
                        lastData = Place(date: today, placemark: placemark)
                        realm.add(lastData)
                    } else { lastData = result[0] }
                    lastLocality = placemark.locality ?? ""
                } else {
                    if !localityList!.contains(placemark.locality!) { localityList?.append(placemark.locality!)
                        isAppended = true
                    }
                }
                currentAdministrativeArea = placemark.administrativeArea ?? ""
                if currentAdministrativeArea != lastAdministrativeArea { localityList = []; needToLoadData = true }
                if needToLoadData {
                    PlaceManager.setLocalityList(cityName: PlaceManager.currentAdministrativeArea)
                    needToLoadData = false
                }
                lastData.distance += distance
                lastAdministrativeArea = currentAdministrativeArea
            }} catch { print(error) }
            }
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
            let key = result.administrativeArea + " / " + result.locality
            if rank.keys.contains(key) {
                rank[key]! += result.distance
            } else {
                rank[key] = result.distance
            }
        }
        return rank.sorted(by: {$0.value > $1.value})
    }
    
    static func setLocalityList(cityName: String) {
        let realm = try! Realm()
        let results = realm.objects(Place.self).filter("'\(cityName)' == administrativeArea")
        for result in results {
            localityList?.append(result.locality)
        }
    }
}
