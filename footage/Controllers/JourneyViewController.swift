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
    
    var journey: Journey! = nil // comes from previous VC (Stats)
    var journeyIndex = 0 // comes from previous VC (Stats)
    var forReloadStatsVC = DateViewController()
    var photoVC: PhotoCollectionVC! = nil
    var bookmark: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainMap.delegate = self
        configureMap()
        setInitialAlpha()
        JourneyAnimation(journeyVC: self, journeyIndex: journeyIndex).journeyActivate()
        configureButtons()
        let results = PhotoManager.loadAssetsAndBookmark(footsteps: journey.footsteps)
        photoVC = PhotoCollectionVC(date: journey.date, assets: results.0, journeyVC: self)
        bookmark = results.1
        addChild(photoVC)
        view.addSubview(photoVC.collectionView)
        slider.maximumValue = Float(journey.footsteps.count - 1)
        slider.value = 0
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
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        DrawOnMap.centerToFootstep(journey.footsteps[Int(sender.value)], on: mainMap)
        if let nextItem = bookmark.firstIndex(of: Int(sender.value)) {
            photoVC.collectionView.scrollToItem(at: IndexPath(item: nextItem + 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    @IBAction func sliderPressed(_ sender: UISlider) {
        PhotoCollectionVC.sliderIsMoving = true
    }
    
    @IBAction func sliderFinished(_ sender: UISlider) {
        PhotoCollectionVC.sliderIsMoving = false
    }
    
    func moveSliderTo(value: Int) {
        DrawOnMap.centerToFootstep(journey.footsteps[value], on: mainMap)
        slider.value = Float(value)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PhotoSelectionVC
        destinationVC.dateFrom = DateConverter.stringToDate(int: journey.date, start: true) as NSDate
        destinationVC.dateTo = DateConverter.stringToDate(int: journey.date, start: false) as NSDate
        destinationVC.photoCollectionVC = photoVC
        destinationVC.journeyVC = self
        destinationVC.footstep = journey.footsteps[Int(slider.value)]
        destinationVC.footstepIndex = Int(slider.value)
    }
}

// MARK: -Maps

extension JourneyViewController: MKMapViewDelegate {
    
    func configureMap() {
        DrawOnMap.setCamera(journey.footsteps, on: mainMap)
        DrawOnMap.polylineFromFootsteps(journey.footsteps, on: mainMap)
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
    
    private func configureButtons() {
        let photoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        photoButton.setImage(#imageLiteral(resourceName: "postAddButton"), for: .normal)
        photoButton.addTarget(self, action: #selector(goToSelection), for: .touchUpInside)
        
        let button = UIButton()
        button.frame = CGRect(x: 100, y: 0, width: 50, height: 50)
        button.setImage(#imageLiteral(resourceName: "addWritingButton"), for: .normal)
        button.addTarget(self, action: #selector(activateTextField), for: .touchUpInside)
        
        view.addSubview(button)
        view.addSubview(photoButton)
    }
    
    @objc func goToSelection() {
        performSegue(withIdentifier: "goToPhotoSelection", sender: self)
    }
    
    @objc func activateTextField() {
        photoVC.addNoteCell()
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

