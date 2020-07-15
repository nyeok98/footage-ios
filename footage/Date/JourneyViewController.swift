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
    @IBOutlet weak var slider: UISlider!
    var centerMark = MKPointAnnotation()
    
    var journeyManager: JourneyManager! = nil
    var dateVC: DateViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journeyManager.journeyVC = self
        mainMap.delegate = self
        configureMap()
        setInitialAlpha()
        JourneyAnimation(journeyManager: journeyManager).journeyActivate()
        configureButtons()
        journeyManager.photoVC = PhotoCollectionVC(journeyManager: journeyManager)
        addChild(journeyManager.photoVC)
        view.addSubview(journeyManager.photoVC.collectionView)
        slider.maximumValue = Float(journeyManager.journey.footsteps.count - 1)
        slider.value = 0
    }
    
    override func viewDidAppear(_ animated: Bool) { // create preview image using screenshot
        let realm = try! Realm()
        let imageData = takeScreenshot().pngData()!
        DateViewController.journeys[journeyManager.journeyIndex].preview = imageData // Is this Okay?
        do {
            try realm.write {
                let object = DateViewController.journeys[journeyManager.journeyIndex].reference
                if let day = object as? DayData {
                    day.preview = imageData
                } else if let month = object as? Month {
                    month.preview = imageData
                } else if let year = object as? Year {
                    year.preview = imageData
                }
            }
        } catch { print(error)}
        dateVC.collectionView.reloadData()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        DrawOnMap.moveCenterTo(journeyManager.journey.footsteps[Int(sender.value)].coordinate, on: mainMap, centerMark: centerMark)
        
        if let nextItem = journeyManager.bookmark.firstIndex(of: Int(sender.value)) {
            journeyManager.photoVC.collectionView.scrollToItem(at: IndexPath(item: 0, section: nextItem), at: .centeredHorizontally, animated: true)
            journeyManager.currentIndexPath = IndexPath(item: 0, section: nextItem)
        }
    }
    @IBAction func sliderPressed(_ sender: UISlider) {
        journeyManager.sliderIsMoving = true
    }
    
    @IBAction func sliderFinished(_ sender: UISlider) {
        journeyManager.sliderIsMoving = false
        // sender.value = round(sender.value)
    }
}

// MARK: -Maps

extension JourneyViewController: MKMapViewDelegate {
    
    func configureMap() {
        mainMap.register(FootAnnotationView.self, forAnnotationViewWithReuseIdentifier: FootAnnotationView.reuseIdentifier)
        mainMap.register(FootTransparentView.self, forAnnotationViewWithReuseIdentifier: FootTransparentView.reuseIdentifier)
        mainMap.addAnnotation(centerMark) // shows where the slider points
        DrawOnMap.moveCenterTo(journeyManager.journey.footsteps[0].coordinate, on: mainMap, centerMark: centerMark)
        DrawOnMap.polylineFromFootsteps(journeyManager.journey.footsteps, on: mainMap)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayWithColor = overlay as! PolylineWithColor
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = overlayWithColor.color
        polylineView.lineWidth = 10
        return polylineView
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is FootAnnotation {
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: FootAnnotationView.reuseIdentifier) else { fatalError("Cannot create new cell") }
            return annotationView
        } else {
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: FootTransparentView.reuseIdentifier) else { fatalError("Cannot create new cell") }
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let footstepNumber = view.annotation?.subtitle else { return }
        guard let sectionNumber = journeyManager.bookmark.firstIndex(of: Int(footstepNumber!) ?? -1) else { return }
        DrawOnMap.moveCenterTo(view.annotation!.coordinate, on: mapView, centerMark: centerMark)
        journeyManager.currentIndexPath = IndexPath(item: 0, section: sectionNumber)
        journeyManager.photoVC.collectionView.scrollToItem(at: IndexPath(item: 0, section: sectionNumber), at: .centeredHorizontally, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "goToPhotoSelection", sender: self)
        } else {
            // add Note
        }
    }
}

// MARK:- Others

extension JourneyViewController {
    
    private func configureButtons() {
        let button = UIButton()
        button.frame = CGRect(x: 100, y: 0, width: 50, height: 50)
        button.setImage(#imageLiteral(resourceName: "addWritingButton"), for: .normal)
        button.addTarget(self, action: #selector(createPin), for: .touchUpInside)
        view.addSubview(button)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PhotoSelectionVC
        destinationVC.journeyManager = journeyManager
        destinationVC.footstepNumber = Int(slider.value)
    }
    
    @objc func createPin() {
        let footstepNumber = Int(slider.value)
        let footstep = journeyManager.journey.footsteps[footstepNumber]
        //DrawOnMap.createPin(footstep, footstepNumber: Int(footstepNumber), on: mainMap)
        mainMap.addAnnotation(FootAnnotation(footstep: footstep, number: footstepNumber))
        DrawOnMap.moveCenterTo(footstep.coordinate, on: mainMap, centerMark: centerMark)
        journeyManager.bookmark.append(footstepNumber)
        journeyManager.bookmark.sort()
        let newSection = journeyManager.bookmark.firstIndex(of: footstepNumber)!
        journeyManager.assets.insert([], at: newSection)
        journeyManager.photoVC.collectionView.insertSections(IndexSet(integer: newSection))
        //journeyManager.photoVC.collectionView.reloadSections(IndexSet(integer: newSection))
    
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
        //youText.alpha = 0
        //seeBackText.alpha = 0
    }
}

class PolylineWithColor: MKPolyline {
    var color: UIColor = .white
}

