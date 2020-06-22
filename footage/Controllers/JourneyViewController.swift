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
    var photoView: PhotoCollection?
    var polyLineColor: String = "#EADE4Cff"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        setInitialAlpha()
        let animation = JourneyAnimation(journeyVC: self, journeyIndex: journeyIndex)
        animation.journeyActivate()
        photoView = PhotoCollection(journey: journeyData)
        addChild(photoView!)
        view.addSubview(photoView!.collectionView)
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
        var colorcheck: String = ""
        for route in journeyData.routes {
            
            var coordinates: [CLLocationCoordinate2D] = []
            polyLineColor = route.footsteps[0].color
            for footstep in route.footsteps {
                if colorcheck != footstep.color {
                    coordinates.append(footstep.coordinate)
                    polyLineColor = colorcheck
                    let newLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
                    self.mainMap.addOverlay(newLine)
                    center = newLine.coordinate
                    coordinates = []
                    coordinates.append(footstep.coordinate)
                    colorcheck = footstep.color
                } else {
                    coordinates.append(footstep.coordinate)
                    
                }
                polyLineColor = colorcheck
                let newLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
                self.mainMap.addOverlay(newLine)
            }
        }
        let locationRegion = MKCoordinateRegion(center: center!, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mainMap.setRegion(locationRegion, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = UIColor(hex: polyLineColor)
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
        { return image! }
        return UIImage()
    }

}

