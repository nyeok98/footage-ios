//
//  DrawOnMap.swift
//  footage
//
//  Created by Wootae on 7/1/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class DrawOnMap {
    
    static func polylineFromFootsteps(_ footsteps: List<Footstep>, on map: MKMapView) {
        var overlays: [PolylineWithColor] = []
        var lastColor = footsteps[0].color
        var coordinates: [CLLocationCoordinate2D] = []
        for footstep in footsteps {
            if footstep.setAsStart {
                if !coordinates.isEmpty {
                    let polyline = PolylineWithColor(coordinates: coordinates, count: coordinates.count)
                    polyline.color = UIColor(hex: lastColor)!
                    overlays.append(polyline)
                }
                lastColor = footstep.color
                coordinates = [footstep.coordinate]
            } else if footstep.color != lastColor {
                coordinates.append(footstep.coordinate)
                let polyline = PolylineWithColor(coordinates: coordinates, count: coordinates.count)
                polyline.color = UIColor(hex: lastColor)!
                overlays.append(polyline)
                lastColor = footstep.color
                coordinates = [footstep.coordinate]
            } else {
                coordinates.append(footstep.coordinate)
            }
        }
        let polyline = PolylineWithColor(coordinates: coordinates, count: coordinates.count)
        polyline.color = UIColor(hex: lastColor)!
        overlays.append(polyline)
        map.addOverlays(overlays, level: .aboveRoads)
    }
    
    static func moveCenterTo (_ coordinate: CLLocationCoordinate2D, on map: MKMapView, centerMark: MKPointAnnotation?) {
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: CLLocationDistance(exactly: 200)!, pitch: 70, heading: CLLocationDirection(exactly: 0)!)
        map.setCamera(camera, animated: false)
        centerMark?.coordinate = coordinate
    }
    
    static func createPin(_ footstep: Footstep, footstepNumber: Int, on map: MKMapView) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = footstep.coordinate
        //annotation.title = UserDefaults.standard.string(forKey: footstep.color)
        annotation.title = "Hi"
        annotation.subtitle = String(footstepNumber)
        map.addAnnotation(annotation)
    }
    
//    func calculateAdjustments(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> (CLLocationDirection, Double, Double) { // TODO: 수학 너무 많아... 나중에 할래
//           let opposite = to.longitude.distance(to: from.longitude)
//           let adjacent = to.latitude.distance(to: from.latitude)
//           let degree = atan(opposite / adjacent)
//           return (CLLocationDirection(degree * 180 / Double.pi - 90), 0.0005 * cos(degree), 0.0005 * sin(degree))
//       }
}

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
        self.image = UIImage(named: "transparentPin")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
