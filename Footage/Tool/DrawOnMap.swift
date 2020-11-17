//
//  DrawOnMap.swift
//  footage
//
//  Created by Wootae on 7/1/20.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class DrawOnMap {
    static func polylineFromFootsteps(_ footsteps: [Footstep], on map: MKMapView) {
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
        map.setCenter(coordinate, animated: false)
        centerMark?.coordinate = coordinate
    }
}
