//
//  FootstepAnnotation.swift
//  Footage
//
//  Created by Wootae Jeon on 2020/11/12.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import Foundation
import MapKit

class FootAnnotation: MKPointAnnotation {
    var number: Int! = nil
    
    init(footstep: Footstep, number: Int) {
        super.init()
        self.title = "사진 추가하기"
        self.coordinate = footstep.coordinate
        self.subtitle = "# " + String(number)
        self.number = number
    }
}

class FootAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "foot-reuse"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true
        self.isEnabled = true
        self.image = UIImage(named: "pin")
        let addPhoto = UIButton(type: .contactAdd)
        self.rightCalloutAccessoryView = addPhoto
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FootTransparentView: MKAnnotationView {
    static let reuseIdentifier = "foot-transparent-reuse"
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.isEnabled = false
        self.isUserInteractionEnabled = false
        self.image = UIImage(named: "transparentPin")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
