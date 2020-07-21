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
    var addButton = UIButton()
    var removeButton = UIButton()
    var footstepLabel = UILabel()
    var journeyManager: JourneyManager! = nil
    var dateVC: DateViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journeyManager.journeyVC = self
        mainMap.delegate = self
        JourneyAnimation(journeyManager: journeyManager).journeyActivate()
        configureMap()
        setInitialAlpha()
        configureButtons()
        journeyManager.photoVC = PhotoCollectionVC(journeyManager: journeyManager)
        addChild(journeyManager.photoVC)
        view.addSubview(journeyManager.photoVC.collectionView)
        slider.maximumValue = Float(journeyManager.journey.footsteps.count - 1)
        slider.value = 0
    }
    
//    override func viewDidAppear(_ animated: Bool) { // create preview image using screenshot
//        let realm = try! Realm()
//        let imageData = takeScreenshot().pngData()!
//        DateViewController.journeys[journeyManager.journeyIndex].preview = imageData // Is this Okay?
//        do {
//            try realm.write {
//                let object = DateViewController.journeys[journeyManager.journeyIndex].reference
//                if let day = object as? DayData {
//                    day.preview = imageData
//                } else if let month = object as? Month {
//                    month.preview = imageData
//                } else if let year = object as? Year {
//                    year.preview = imageData
//                }
//            }
//        } catch { print(error)}
//        dateVC.collectionView.reloadData()
//    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        addButton.alpha = 1
        addButton.isUserInteractionEnabled = true
        footstepLabel.alpha = 0.5
        footstepLabel.text = "# " + String(Int(sender.value))
        DrawOnMap.moveCenterTo(journeyManager.journey.footsteps[Int(sender.value)].coordinate, on: mainMap, centerMark: centerMark)
        if let nextItem = journeyManager.bookmark.lastIndex(of: Int(sender.value)) {
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
        mainMap.addAnnotations(journeyManager.loadAnnotations())
        DrawOnMap.moveCenterTo(journeyManager.journey.footsteps[0].coordinate, on: mainMap, centerMark: centerMark)
        DrawOnMap.polylineFromFootsteps(journeyManager.journey.footsteps, on: mainMap)
    }
    
    @objc func createPin() {
        let footstepNumber = Int(slider.value)
        let footstep = journeyManager.journey.footsteps[footstepNumber]
        let newAnnotation = FootAnnotation(footstep: footstep, number: footstepNumber)
        mainMap.addAnnotation(newAnnotation)
        DrawOnMap.moveCenterTo(footstep.coordinate, on: mainMap, centerMark: centerMark)
        journeyManager.prepareNewFootstep(footstepNumber: footstepNumber, annotation: newAnnotation)
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
        guard let footAnnotation = view.annotation as? FootAnnotation else { return }
        guard let sectionNumber = journeyManager.bookmark.lastIndex(of: footAnnotation.number) else { return }
        slider.value = Float(footAnnotation.number)
        DrawOnMap.moveCenterTo(view.annotation!.coordinate, on: mapView, centerMark: centerMark)
        journeyManager.selectedPin = view
        journeyManager.currentIndexPath = IndexPath(item: 0, section: sectionNumber)
        journeyManager.photoVC.collectionView.scrollToItem(at: IndexPath(item: 0, section: sectionNumber), at: .centeredHorizontally, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) { performSegue(withIdentifier: "goToPhotoSelection", sender: self) }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PhotoSelectionVC
        destinationVC.journeyManager = journeyManager
        destinationVC.footstepNumber = Int(slider.value)
    }

}

// MARK:- Others

extension JourneyViewController {
    
    private func configureButtons() {
        addButton = UIButton(frame: CGRect(x: K.screenWidth * 0.1, y: K.screenHeight * 0.435, width: 50, height: 50))
        addButton.setImage(#imageLiteral(resourceName: "addFootstep"), for: .normal)
        addButton.addTarget(self, action: #selector(createPin), for: .touchUpInside)
        view.addSubview(addButton)
        removeButton = UIButton(frame: CGRect(x: K.screenWidth * 0.72, y: K.screenHeight * 0.44, width: 60, height: 40))
        removeButton.setImage(#imageLiteral(resourceName: "amendButton"), for: .normal)
        removeButton.addTarget(self, action: #selector(activateRemove), for: .touchUpInside)
        view.addSubview(removeButton)
        footstepLabel = UILabel(frame: CGRect(x: K.screenWidth * 0.13, y: K.screenHeight * 0.47, width: 100, height: 50))
        footstepLabel.font = UIFont(name: "NanumBarunpen-Regular", size: 25)
        footstepLabel.text = "# 0"
        footstepLabel.backgroundColor = .clear
        footstepLabel.alpha = 0.5
        footstepLabel.layer.shadowColor = UIColor.gray.cgColor
        footstepLabel.layer.shadowRadius = 1.0
        footstepLabel.layer.shadowOpacity = 1.0
        footstepLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.addSubview(footstepLabel)
    }
    
    @objc func activateRemove() {
        journeyManager.removeActivated = true
        removeButton.setImage(#imageLiteral(resourceName: "complete_button"), for: .normal)
        removeButton.removeTarget(self, action: #selector(activateRemove), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(disableRemove), for: .touchUpInside)
        guard let collectionView = journeyManager.photoVC.collectionView else {return}
        for section in 0..<collectionView.numberOfSections {
            if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: section)) as? GroupCell {
                cell.showRemove()
            }
        }
        let expandedSection = journeyManager.expandedSection
        if expandedSection > 0 {
            for item in 0..<collectionView.numberOfItems(inSection: expandedSection) {
                if let cell = collectionView.cellForItem(at: IndexPath(item: item, section: expandedSection)) as? CardCell {
                    cell.showRemove()
                }
            }
        }
    }
    
    @objc func disableRemove() {
        journeyManager.removeActivated = false
        removeButton.setImage(#imageLiteral(resourceName: "amendButton"), for: .normal)
        removeButton.removeTarget(self, action: #selector(disableRemove), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(activateRemove), for: .touchUpInside)
        guard let collectionView = journeyManager.photoVC.collectionView else {return}
        for section in 0..<collectionView.numberOfSections {
            if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: section)) as? GroupCell {
                cell.hideRemove()
            }
        }
        let expandedSection = journeyManager.expandedSection
        if expandedSection > 0 {
            for item in 0..<collectionView.numberOfItems(inSection: expandedSection) {
                if let cell = collectionView.cellForItem(at: IndexPath(item: item, section: expandedSection)) as? CardCell {
                    cell.hideRemove()
                }
            }
        }
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
    }
}

class PolylineWithColor: MKPolyline {
    var color: UIColor = .white
}

