//
//  JourneyViewController.swift
//  footage
//
//  Created by Wootae on 6/15/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import MapKit
import EFCountingLabel

class JourneyViewController: UIViewController, MKMapViewDelegate {
    
    //components which Wootae is gonna make it fuctuate.
    @IBOutlet weak var mainMap: MKMapView!
    
    @IBOutlet weak var yearLabel: EFCountingLabel!
    @IBOutlet weak var monthLabel: EFCountingLabel!
    @IBOutlet weak var dayLabel: EFCountingLabel!
    
    //Not related to you, Wootae!
    @IBOutlet weak var youLabel: UILabel!
    @IBOutlet weak var seeBackLabel: UILabel!
    
    var journeyData: JourneyData? = nil
    var journeyIndex = 0
    var forReloadStatsVC = StatsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        setInitialAlpha()
        JourneyAnimation.journeyActivate(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let image = takeScreenshot()
        StatsViewController.journeyArray[journeyIndex].previewImage = image
        forReloadStatsVC.collectionView.reloadData()
    }
    
    func setInitialAlpha() {
        yearLabel.alpha = 0
        monthLabel.alpha = 0
        dayLabel.alpha = 0
        youLabel.alpha = 0
        seeBackLabel.alpha = 0
    }
    
    func configureMap() {
        mainMap.delegate = self
        mainMap.mapType = MKMapType.standard
        var center: CLLocationCoordinate2D?
        
        for route in journeyData!.footstepArray {
            var coordinates: [CLLocationCoordinate2D] = []
            for footstep in route {
                coordinates.append(footstep.coordinate)
            }
            let newLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mainMap.addOverlay(newLine)
            center = newLine.coordinate
        }
        let locationRegion = MKCoordinateRegion(center: center!, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mainMap.setRegion(locationRegion, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = UIColor(named: "mainColor")
        polylineView.lineWidth = 10
        return polylineView
    }
    
    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(mainMap.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        mainMap.drawHierarchy(in: mainMap.bounds, afterScreenUpdates: false)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }

}
