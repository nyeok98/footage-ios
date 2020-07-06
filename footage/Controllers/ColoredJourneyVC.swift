//
//  ColoredJourneyVC.swift
//  footage
//
//  Created by Wootae on 7/4/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import MapKit

class ColoredJourneyVC: UIViewController, MKMapViewDelegate {
    var color: String = ""
    @IBOutlet weak var mainMap: MKMapView!
    @IBOutlet weak var colorImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainMap.delegate = self
        configureMap()
        setColorImage(name: color)
    }
    
    func loadJourney() {
        
    }
    
    func configureMap() {
        let heading = CLLocationDirection(exactly: 0)
        let days = DateConverter.lastMondayToday()
        let footstepsArray = ColorManager.footstepsWithColor(color: color, from: days.0, to: days.1)
        let firstPosition = footstepsArray[0][0].coordinate
        let camera = MKMapCamera(lookingAtCenter: firstPosition, fromDistance: CLLocationDistance(exactly: 400)!, pitch: 70, heading: heading!)
        mainMap.setCamera(camera, animated: false)
        for footsteps in footstepsArray {
            DrawOnMap.polylineFromFootsteps(footsteps, on: mainMap)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayWithColor = overlay as! PolylineWithColor
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = overlayWithColor.color
        polylineView.lineWidth = 10
        return polylineView
    }
    
    func setColorImage(name: String) {
        colorImage.image = UIImage(named: name)
    }
}
