//
//  MKMapView+Polyline.swift
//  Footage
//
//  Created by Wootae Jeon on 2020/11/12.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func drawPolyline(from footsteps: [Footstep]) {
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
        addOverlays(overlays, level: .aboveRoads)
    }
}
