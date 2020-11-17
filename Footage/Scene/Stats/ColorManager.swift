//
//  ColorManager.swift
//  footage
//
//  Created by Wootae on 6/30/20.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import Foundation
import RealmSwift

class ColorManager {

    static var lastColor = ""
    static var lastData: Color! = nil
    
    static func update(hex newColor: String, distance: Double) {
        let realm = try! Realm()
        do { try realm.write {
        if lastColor == "" || newColor != lastColor {
            lastColor = newColor
            let today = DateConverter.dateToDay(date: Date())
            let result = realm.objects(Color.self).filter("date == \(today) AND hex == '\(newColor)'")
            if result.isEmpty {
                lastData = Color(date: today, hex: newColor)
                realm.add(lastData) // FIX LATER
            } else { lastData = result[0] }
        }
            lastData.distance += distance
        }} catch { print(error) }
    }
    
    static func getDistance(hex: String, startDate: Int, endDate: Int) -> Double { // dates are inclusive
        let realm = try! Realm()
        var distance = 0.0
        let result = realm.objects(Color.self).filter("date >= \(startDate) AND date <= \(endDate) AND hex == '\(hex)'")
        for day in result { distance += day.distance }
        return distance
    }
    
    static func getRankingDistance(startDate: Int, endDate: Int) -> Array<(key: String, value: Double)> {
        // returns [(key: "#2E45DF91", value: 3.2), (key: "#DF7E235D", value: 2.2) ... ]
        var rank: [String: Double] = [:]
        let realm = try! Realm()
        let results = realm.objects(Color.self).filter("date >= \(startDate) AND date <= \(endDate)")
        for result in results {
            let key = result.hex
            if rank.keys.contains(key) {
                rank[key]! += result.distance
            } else {
                rank[key] = result.distance
            }
        }
        return rank.sorted(by: {$0.value > $1.value})
    }
    
    static func footstepsWithColor(color: String, from: Int, to:Int) -> [List<Footstep>] {
        var footsteps: [List<Footstep>] = []
        let realm = try! Realm()
        var colorChanged = true
        var arrayIndex = 0
        footsteps.append(List<Footstep>())
        let result = realm.objects(DayData.self).filter("date >= \(from) AND date <= \(to)")
        for day in result {
            for footstep in day.footsteps {
                if footstep.color == color {
                    footsteps[arrayIndex].append(footstep)
                } else {
                    if !colorChanged {
                        colorChanged = true
                        footsteps.append(List<Footstep>())
                        arrayIndex += 1
                    }
                }
            }
        }
        return footsteps
    }
}
