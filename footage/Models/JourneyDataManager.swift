//
//  JourneyByMonth.swift
//  footage
//
//  Created by Wootae on 6/20/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class JourneyDataManager { // journey 저장 및 데이터 가공을 담당
    
//    static var JourneyByDay: [Int: JourneyData] = [:]
//    static var JourneyByMonth: [Int: JourneyData] = [:]
//    static var JourneyByYear: [Int: JourneyData] = [:]

    static func collectJourneyData(footstep: Footstep) { //
        let realm = try! Realm()
        let dateFormatter = DateFormatter()
        let date = footstep.timestamp
        
        dateFormatter.dateFormat = "yyyyMMdd"  // 20200616
        let day = Int(dateFormatter.string(from: date))!
        dateFormatter.dateFormat = "yyyyMM" // 202006
        let month = Int(dateFormatter.string(from: date))!
        dateFormatter.dateFormat = "yyyy" // 2020
        let year = Int(dateFormatter.string(from: date))!
        
        do {
            try realm.write {
                let relatedJourneys = realm.objects(JourneyData.self)
                    .filter("date IN {\(day), \(month), \(year)}")
                switch relatedJourneys.count {
                case 3: // record for today already created (오늘 처음 걷는거 아님)
                    for journey in relatedJourneys {
                        if footstep.isNewStartingPoint {
                            journey.routes.append(Route(withSingle: footstep))
                        } else {
                            journey.routes[journey.routes.count - 1].footsteps.append(footstep)
                        }
                    }
                case 2: // first time today, but not first this month
                    for journey in relatedJourneys {
                        journey.routes.append(Route(withSingle: footstep))
                    }
                    realm.add(JourneyData(route: Route(withSingle: footstep), date: day))
                case 1: // first time this month, but not this year
                    for journey in relatedJourneys {
                        journey.routes.append(Route(withSingle: footstep))
                    }
                    realm.add(JourneyData(route: Route(withSingle: footstep), date: day))
                    realm.add(JourneyData(route: Route(withSingle: footstep), date: month))
                default: // first time this year
                    realm.add(JourneyData(route: Route(withSingle: footstep), date: day))
                    realm.add(JourneyData(route: Route(withSingle: footstep), date: month))
                    realm.add(JourneyData(route: Route(withSingle: footstep), date: year))
                }
            }
        } catch {
            print(error)
        }
    }
    
//    static func updateToRealm(_ day: Int, _ month: Int, _ year: Int) {
//        let realm = try! Realm()
//        do {
//            try realm.write {
//                realm.add(JourneyByDay[day]!)
//                realm.add(JourneyByMonth[month]!)
//                realm.add(JourneyByYear[year]!)
//            }
//        } catch {
//            print(error)
//        }
//    }
    
    static func loadFromRealm(rangeOf: String = "") -> Results<JourneyData> {
        let realm = try! Realm()
        switch rangeOf {
        case "day":
            return realm.objects(JourneyData.self).filter("1000000 < date") // 20200604
        case "month":
            return realm.objects(JourneyData.self).filter("10000 < date && date < 1000000") // 202006
        default: // year
            return realm.objects(JourneyData.self).filter("date < 10000") // 2020
        }
    }
}
