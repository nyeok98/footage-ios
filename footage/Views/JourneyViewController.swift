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
        // Do any additional setup after loading the view.
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
        print("setIntitalAlpha is functuated")
    }
    
    func configureMap() {
        mainMap.delegate = self
        mainMap.mapType = MKMapType.standard
        var center: CLLocationCoordinate2D?
        for coordinates in journeyData!.polylineArray {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
