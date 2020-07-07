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
    
    static func setCamera(_ footsteps: List<Footstep>, on map: MKMapView) {
        var heading = CLLocationDirection(exactly: 0)
        var firstPosition = footsteps[0].coordinate
        var secondPosition = firstPosition
        //        if journey.footsteps.count >= 2 {
        //            secondPosition = journey.footsteps[1].coordinate
        //            let adjustments = calculateAdjustments(from: firstPosition, to: secondPosition)
        //            heading = adjustments.0
        //            firstPosition = CLLocationCoordinate2DMake(firstPosition.latitude + adjustments.1, firstPosition.longitude + adjustments.2)
        //        }
        let camera = MKMapCamera(lookingAtCenter: firstPosition, fromDistance: CLLocationDistance(exactly: 400)!, pitch: 70, heading: heading!)
        map.setCamera(camera, animated: false)
    }
    
    static func centerToFootstep (_ footstep: Footstep, on map: MKMapView) {
        let camera = MKMapCamera(lookingAtCenter: footstep.coordinate, fromDistance: CLLocationDistance(exactly: 200)!, pitch: 70, heading: CLLocationDirection(exactly: 90)!)
        map.setCamera(camera, animated: false)
    }
    
    static func createPin() { }
}
