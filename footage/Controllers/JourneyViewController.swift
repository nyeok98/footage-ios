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

class JourneyViewController: UIViewController {
    
    @IBOutlet weak var mainMap: MKMapView!
    @IBOutlet weak var yearLabel: EFCountingLabel!
    @IBOutlet weak var monthLabel: EFCountingLabel!
    @IBOutlet weak var dayLabel: EFCountingLabel!
    @IBOutlet weak var yearText: UILabel!
    @IBOutlet weak var monthText: UILabel!
    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var youText: UILabel!
    @IBOutlet weak var seeBackText: UILabel!
    
    var journey: Journey! = nil // comes from previous VC (Stats)
    var journeyIndex = 0 // comes from previous VC (Stats)
    var forReloadStatsVC = DateViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainMap.delegate = self
        configureMap()
        setInitialAlpha()
        JourneyAnimation(journeyVC: self, journeyIndex: journeyIndex).journeyActivate()
        let photoVC = PhotoCollectionVC()
        addChild(photoVC)
        view.addSubview(photoVC.collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) { // create preview image using screenshot
        let realm = try! Realm()
        let imageData = takeScreenshot().pngData()!
        DateViewController.journeys[journeyIndex].preview = imageData
        do {
            try realm.write {
                let object = DateViewController.journeys[journeyIndex].reference
                if let day = object as? DayData {
                    day.preview = imageData
                } else if let month = object as? Month {
                    month.preview = imageData
                } else if let year = object as? Year {
                    year.preview = imageData
                }
            }
        } catch { print(error)}
        forReloadStatsVC.collectionView.reloadData()
    }
}

// MARK: -Maps

extension JourneyViewController: MKMapViewDelegate {
    
    func configureMap() {
        var heading = CLLocationDirection(exactly: 0)
        var firstPosition = journey.footsteps[0].coordinate
        var secondPosition = firstPosition
//        if journey.footsteps.count >= 2 {
//            secondPosition = journey.footsteps[1].coordinate
//            let adjustments = calculateAdjustments(from: firstPosition, to: secondPosition)
//            heading = adjustments.0
//            firstPosition = CLLocationCoordinate2DMake(firstPosition.latitude + adjustments.1, firstPosition.longitude + adjustments.2)
//        }
        let camera = MKMapCamera(lookingAtCenter: firstPosition, fromDistance: CLLocationDistance(exactly: 400)!, pitch: 70, heading: heading!)
        mainMap.setCamera(camera, animated: false)
        DrawOnMap.polylineFromJourney(journey, on: mainMap)
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
}

// MARK:- Others

extension JourneyViewController {
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PhotoSelectionVC
        destinationVC.dateFrom = DateConverter.stringToDate(int: journey.date, start: true) as NSDate
        destinationVC.dateTo = DateConverter.stringToDate(int: journey.date, start: false) as NSDate
    }
}

class PolylineWithColor: MKPolyline {
    var color: UIColor = .white
}

