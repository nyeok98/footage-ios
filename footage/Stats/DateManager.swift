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

class DateManager { // journey 저장 및 데이터 가공을 담당
    
    static var lastData: DayData?
    
    static func loadTodayData() {
        let realm = try! Realm()
        let today = DateConverter.dateToDay(date: Date())
        let todayResult = realm.objects(DayData.self).filter("date == \(today)")
        if !todayResult.isEmpty {
            DateManager.lastData = todayResult[0]
        }
    }

    static func update(footstep: Footstep, distance: Double) { //
        let realm = try! Realm()
        do { try realm.write {
            if let todayData = lastData { // today's data is already initiated
                todayData.footsteps.append(footstep)
                todayData.distance += distance
            } else { // first walk of the day!
                let today = DateConverter.dateToDay(date: Date())
                lastData = DayData(date: today)
                //lastData?.footsteps.append(footstep)
                lastData?.footsteps.append(footstep) // 이거 왜 했는지는 모르지만 알고 있자!!!
                realm.add(lastData!) //
                let thisMonth = DateConverter.dateToMonth(date: Date())
                let monthResult = realm.objects(Month.self).filter("date == \(thisMonth)")
                if monthResult.isEmpty { // first walk of the month
                    let month = Month(date: thisMonth)
                    month.days.append(lastData!)
                    realm.add(month)
                    let thisYear = DateConverter.dateToYear(date: Date())
                    let yearResult = realm.objects(Year.self).filter("date == \(thisYear)")
                    if yearResult.isEmpty { // first walk of the year
                        let year = Year(date: thisYear)
                        year.months.append(month)
                        realm.add(year)
                    } else { yearResult[0].months.append(month) } // not first this year
                } else { monthResult[0].days.append(lastData!) } // not first this month
            }
        }} catch { print(error) }
    }
    
    static func loadFromRealm(rangeOf: String = "year") -> [Journey] {
        let realm = try! Realm()
        var journeys: [Journey] = []
        switch rangeOf {
        case "day":
            let result = realm.objects(DayData.self).sorted(byKeyPath: "date", ascending: false) // 20200604
            for day in result {
                let journey = Journey.init(footsteps: day.footsteps, preview: day.preview, reference: day, date: day.date)
                journeys.append(journey)
            }
            return journeys
        case "month":
            let result = realm.objects(Month.self)
            for month in result {
                let footsteps = List<Footstep>()
                for day in month.days {
                    footsteps.append(objectsIn: day.footsteps)
                }
                let journey = Journey.init(footsteps: footsteps, preview: month.preview, reference: month, date: month.date)
                journeys.append(journey)
            }
            return journeys
        case "year":
            let result = realm.objects(Year.self)
            for year in result {
                let footsteps = List<Footstep>()
                for month in year.months {
                    for day in month.days {
                        footsteps.append(objectsIn: day.footsteps)
                    }
                }
                let journey = Journey.init(footsteps: footsteps, preview: year.preview, reference: year, date: year.date)
                journeys.append(journey)
            }
            return journeys
        default: // for loading single journey ex) HomeVC today journey
            let result = realm.objects(DayData.self).filter("date == \(rangeOf)") // 20200604
            for day in result {
                let journey = Journey.init(footsteps: day.footsteps, preview: day.preview, reference: day, date: day.date)
                journeys.append(journey)
            }
            return journeys
        }
    }
}

// MARK: - Distance

extension DateManager {
    
    static func loadDistance(total: Bool) -> Double { // true: load total / false: load today
        let realm = try! Realm()
        // print("Realm is located at:", realm.configuration.fileURL!)
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
            let today = DateConverter.dateToDay(date: Date())
            let journeyToday = realm.objects(DayData.self).filter("date == \(today)")
            if journeyToday.isEmpty { return 0 }
            else {
                return journeyToday[0].distance
            }
        }
        return 0 // unused
    }
    
    static func loadMonthlyDistance() -> Double {
        let realm = try! Realm()
        let today = DateConverter.dateToDay(date: Date())
        let thisMonthStart = DateConverter.tagToMonth(year: today/10000, tag: (today/100)%100, start: true)
        let thisMonthFinish = DateConverter.tagToMonth(year: today/10000, tag: (today/100)%100, start: false)
        let journeys = realm.objects(DayData.self).filter("date >= \(thisMonthStart) && date <= \(thisMonthFinish)")
        if journeys.isEmpty { return 0 }
        else {
            var distance = 0.0
            for day in journeys {
                distance += day.distance
            }
            return distance
        }
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

// MARK: - Photos

extension DateManager {
//    static func savePhotos(data: [)
}
