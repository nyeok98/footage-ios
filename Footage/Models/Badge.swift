//
//  Badge.swift
//  footage
//
//  Created by 녘 on 2020/07/17.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import RealmSwift

class Badge: Object {
    @objc dynamic var detail: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var imageName: String = ""
    @objc dynamic var date: String = ""
    
    required override init() {
        super.init()
    }
    
    init(type: String, imageName: String, detail: String) {
        super.init()
        self.detail = detail
        self.type = type
        self.imageName = imageName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        self.date = dateFormatter.string(from: Date())
    }
}
