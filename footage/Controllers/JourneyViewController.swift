//
//  JourneyViewController.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import MapKit

class JourneyViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mainMap: MKMapView!
    var journeyData: JourneyData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        // Do any additional setup after loading the view.
    }
    
    func configureMap() {
        mainMap.delegate = self
        mainMap.mapType = MKMapType.standard
        for coordinates in journeyData!.polylineArray {
            let newLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mainMap.addOverlay(newLine)
        }
        mainMap.setRegion(MKCoordinateRegion(newLine.boundingMapRect), animated: true)
        mainMap.setRegion
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = UIColor(named: "mainColor")
        polylineView.lineWidth = 10
        return polylineView
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
