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
    
    var journeyData: JourneyData = JourneyData() // comes from previous VC (Stats)
    var journeyIndex = 0 // comes from previous VC (Stats)
    var forReloadStatsVC = StatsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainMap.delegate = self
        configureMap()
        setInitialAlpha()
        JourneyAnimation(journeyVC: self, journeyIndex: journeyIndex).journeyActivate()
        let photoVC = PhotoCollection(journey: journeyData)
        addChild(photoVC)
        view.addSubview(photoVC.collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let realm = try! Realm()
        let image = takeScreenshot()
        do {
            try realm.write {
                StatsViewController.journeyArray[journeyIndex].previewImage = image.pngData()
            }
        } catch { print(error)}
        forReloadStatsVC.collectionView.reloadData()
    }
    
    
    func configureMap() {
        var overlays: [PolylineWithColor] = []
        for route in journeyData.routes {
            var lastColor: String = route.footsteps[0].color
            var coordinates: [CLLocationCoordinate2D] = []
            for footstep in route.footsteps {
                coordinates.append(footstep.coordinate)
                if lastColor != footstep.color { // new color
                    let polyline = PolylineWithColor(coordinates: coordinates, count: coordinates.count)
                    polyline.color = UIColor(hex: lastColor)!
                    overlays.append(polyline)
                    lastColor = footstep.color
                    coordinates = []
                }
            }
            let polyline = PolylineWithColor(coordinates: coordinates, count: coordinates.count)
            polyline.color = UIColor(hex: lastColor)!
            overlays.append(polyline)
        }
        var heading = CLLocationDirection(exactly: 0)
        var firstPosition = journeyData.routes[0].footsteps[0].coordinate
        var secondPosition = firstPosition
        if journeyData.routes.count >= 2 {
            secondPosition = journeyData.routes[1].footsteps[0].coordinate
            let adjustments = calculateAdjustments(from: firstPosition, to: secondPosition)
            heading = adjustments.0
            firstPosition = CLLocationCoordinate2DMake(firstPosition.latitude + adjustments.1, firstPosition.longitude + adjustments.2)
        }
        let camera = MKMapCamera(lookingAtCenter: firstPosition, fromDistance: CLLocationDistance(exactly: 400)!, pitch: 70, heading: heading!)
        mainMap.setCamera(camera, animated: false)
        mainMap.addOverlays(overlays, level: .aboveRoads)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayWithColor = overlay as! PolylineWithColor
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = overlayWithColor.color
        polylineView.lineWidth = 10
        return polylineView
    }
    
    func calculateAdjustments(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> (CLLocationDirection, Double, Double) { // TODO: 수학 너무 많아... 나중에 할래
        let opposite = to.longitude.distance(to: from.longitude)
        let adjacent = to.latitude.distance(to: from.latitude)
        let degree = atan(opposite / adjacent)
        return (CLLocationDirection(degree * 180 / Double.pi - 90), 0.0005 * cos(degree), 0.0005 * sin(degree))
    }
    
    
    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(mainMap.bounds.size, false, UIScreen.main.scale)
        mainMap.drawHierarchy(in: mainMap.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil)
        { return image! }
        return UIImage()
    }
    
    func setInitialAlpha() {
        yearLabel.alpha = 0
        monthLabel.alpha = 0
        dayLabel.alpha = 0
        youText.alpha = 0
        seeBackText.alpha = 0
    }
    
    class PolylineWithColor: MKPolyline {
        var color: UIColor = .white
    }

}

