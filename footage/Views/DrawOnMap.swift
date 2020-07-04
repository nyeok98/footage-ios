//
//  DrawOnMap.swift
//  footage
//
//  Created by Wootae on 7/1/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit

class DrawOnMap {
    
    static func polylineFromJourney(_ journey: Journey, on map: MKMapView) {
        var overlays: [PolylineWithColor] = []
        var lastColor = ""
        var coordinates: [CLLocationCoordinate2D] = []
        for footstep in journey.footsteps {
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
}
