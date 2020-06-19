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
import RealmSwift

class JourneyViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mainMap: MKMapView!
    
    @IBOutlet weak var yearLabel: EFCountingLabel!
    @IBOutlet weak var monthLabel: EFCountingLabel!
    @IBOutlet weak var dayLabel: EFCountingLabel!
    @IBOutlet weak var yearText: UILabel!
    @IBOutlet weak var monthText: UILabel!
    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var youText: UILabel!
    @IBOutlet weak var seeBackText: UILabel!
    
    var journeyData: JourneyData = JourneyData()
    var journeyIndex = 0
    var forReloadStatsVC = StatsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        setInitialAlpha()
        let animation = JourneyAnimation(journeyVC: self, journeyIndex: journeyIndex)
        animation.journeyActivate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let realm = try! Realm()
        let image = takeScreenshot()
        do {
            try realm.write {
                StatsViewController.journeyArray[journeyIndex].previewImage = image.pngData()
            }
        } catch {
            print(error)
        }
        forReloadStatsVC.collectionView.reloadData()
    }
    
    func setInitialAlpha() {
        yearLabel.alpha = 0
        monthLabel.alpha = 0
        dayLabel.alpha = 0
        youText.alpha = 0
        seeBackText.alpha = 0
    }
    
    func configureMap() {
        mainMap.delegate = self
        mainMap.mapType = MKMapType.standard
        var center: CLLocationCoordinate2D?
        
        for route in journeyData.routes {
            var coordinates: [CLLocationCoordinate2D] = []
            for footstep in route.footsteps {
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
