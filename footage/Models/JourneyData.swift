//
//  JourneyData.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit

class JourneyData: NSObject { // Stats 에서 하나의 셀 -> Journey 화면을 구성하는 데이터형
    
    override init() {
        super.init()
    }
    
    init(polylines: [[CLLocationCoordinate2D]], date: String) {
        self.polylineArray = polylines
        self.date = date
    }
    
    var polylineArray: [[CLLocationCoordinate2D]] = []
    var date: String = ""
    var previewImage: UIImage = #imageLiteral(resourceName: "basicStatsIcon")
    
//    static var byMonth: [String: [JourneyData]] = ["2020 06": []]
//    static var polylinebyMonth: [String: [[CLLocationCoordinate2D]]] { // computed property from byMonth
//        get {
//            var toReturn: [String: [[CLLocationCoordinate2D]]] = [:]
//            for (month, journeyArray) in byMonth {
//                toReturn[month] = []
//                for journey in journeyArray {
//                    toReturn[month]!.append(contentsOf: journey.polylineArray)
//                }
//            }
//            return toReturn
//        }
//    }
//    if sender.selectedSegmentIndex == 1 { // month selected
//        StatsViewController.journeyArray = []
//        for (month, polylines) in JourneyData.polylinebyMonth {
//            StatsViewController.journeyArray.append(JourneyData(polylines: polylines, date: month + "월"))
//        }
//    }
    
}
