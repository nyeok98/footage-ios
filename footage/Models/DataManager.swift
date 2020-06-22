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

class DataManager { // journey 저장 및 데이터 가공을 담당

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
                            let latestRoute = journey.routes[journey.routes.count - 1]
                            journey.routes[journey.routes.count - 1].distance += calculateDistance(from: latestRoute.footsteps[latestRoute.footsteps.count - 1], to: footstep)
                            latestRoute.footsteps.append(footstep)
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
    
    static func loadFromRealm(rangeOf: String = "all") -> Results<JourneyData> {
        let realm = try! Realm()
        switch rangeOf {
        case "day":
            return realm.objects(JourneyData.self).filter("1000000 < date") // 20200604
        case "month":
            return realm.objects(JourneyData.self).filter("10000 < date && date < 1000000") // 202006
        case "year":
            return realm.objects(JourneyData.self).filter("date < 10000") // 2020
        case "all": // return all
            return realm.objects(JourneyData.self)
        default:
            return realm.objects(JourneyData.self).filter("date = \(Int(rangeOf) ?? 0)")
        }
    }
}

// MARK: - Distance
extension DataManager {
    
    static func loadDistance(total: Bool) -> Double { // true: load total / false: load today
        let realm = try! Realm()
        if total { // return total distance
            let distance = realm.objects(Distance.self)
            if distance.isEmpty { // TotalDistance has not been initialized
                do {
                    try realm.write { realm.add(Distance()) }
                    return 0
                } catch {
                    print(error)
                }
            } else { return distance[0].total }
        } else { // return today distance
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"  // 20200616
            let day = Int(dateFormatter.string(from: date))!
            let journeyToday = realm.objects(JourneyData.self).filter("date == \(day)")
            if journeyToday.isEmpty { return 0 }
            else {
                var distance = 0.0
                for route in journeyToday[0].routes {
                    distance += route.distance
                }
                return distance
            }
        }
        return 0 // unused
    }
    
    static func saveTotalDistance(value: Double) {
        let realm = try! Realm()
        let distance = realm.objects(Distance.self)[0]
        do {
            try realm.write {
                distance.total = value
            }
        } catch {
            print(error)
        }
    }
    
    static func calculateDistance(from: Footstep, to: Footstep) -> Double {
        return CLLocation(latitude: to.latitude, longitude: to.longitude)
            .distance(from: CLLocation(latitude: from.latitude, longitude: from.longitude))
    }
}
