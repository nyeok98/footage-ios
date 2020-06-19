//
//  JourneyData.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class JourneyData: Object { // Stats 에서 하나의 셀 -> Journey 화면을 구성하는 데이터형
    
    required init() {
        super.init()
    }
    
    init(route: Route, date: Int) {
        super.init()
        self.routes.append(route)
        self.date = date
    }
    
    @objc dynamic var date: Int = 0
    @objc dynamic var previewImage = #imageLiteral(resourceName: "basicStatsIcon").pngData()
    let routes = List<Route>()
}
