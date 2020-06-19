//
//  ViewController.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import MapKit
import EFCountingLabel

class HomeViewController: UIViewController {
    
    static let locationManager = CLLocationManager()
    var locationArray: [[CLLocation]] = [[]]
    
    static var distanceToday: Double = 0
    var dateFormatter =  DateFormatter()
    var locationTimer: Timer?
    var setAsStart: Bool = true
    
    var speedLimit: Double = 8
    var refreshRate: Double = 2.5
    var distanceLimit: Double {
        get {
            return speedLimit * refreshRate
        }
    }
    static var currentStartButtonImage: UIImage?
    
    @IBOutlet weak var mainMap: MKMapView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var youString: UILabel!
    @IBOutlet weak var todayString: UILabel!
    @IBOutlet weak var footString: UILabel!
    @IBOutlet weak var triangle1: UIImageView!
    @IBOutlet weak var triangle2: UIImageView!
    @IBOutlet weak var triangle3: UIImageView!
    @IBOutlet weak var triangle4: UIImageView!
    @IBOutlet weak var triangle5: UIImageView!
    @IBOutlet weak var square1: UIImageView!
    @IBOutlet weak var square2: UIImageView!
    @IBOutlet weak var square3: UIImageView!
    @IBOutlet weak var square4: UIImageView!
    @IBOutlet weak var distance: EFCountingLabel!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainMap.delegate = self
        HomeViewController.locationManager.delegate = self
        
        startButton.setImage(#imageLiteral(resourceName: "start_btn"), for: .normal)
        HomeViewController.currentStartButtonImage = startButton.currentImage
        setInitialAlpha()
        setInitialPositionTriangle()
        HomeAnimation.homeStopAnimation(self)
        
        configureInitialMapView()
    }
    
    func setInitialAlpha() {
        startButton.alpha = 0
        square1.alpha = 0
        square2.alpha = 0
        square3.alpha = 0
        square4.alpha = 0
        triangle1.alpha = 0
        triangle2.alpha = 0
        triangle3.alpha = 0
        triangle4.alpha = 0
        triangle5.alpha = 0
        distanceView.alpha = 0
        unitLabel.alpha = 0
    }
    
    func setInitialPositionTriangle() {
        triangle1.frame.origin.y = -40
        triangle2.frame.origin.y = -40
        triangle3.frame.origin.y = -40
        triangle4.frame.origin.y = -40
        triangle5.frame.origin.y = -40
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        if startButton.currentImage == #imageLiteral(resourceName: "start_btn") { // FROM START TO STOP
            
            HomeViewController.currentStartButtonImage = #imageLiteral(resourceName: "stop_btn")
            HomeViewController.locationManager.requestAlwaysAuthorization()
            
            let status = CLLocationManager.authorizationStatus()
            
            if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
                
                // present an alert indicating location authorization required
                // and offer to take the user to Settings for the app via
                // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
                
                let alert = UIAlertController(title: "위치를 알 수 없어요", message: "소중한 발자취를 위해 위치서비스를 '항상'으로 켜주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { (_) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                HomeAnimation.homeStartAnimation(self)
//                locationManager.startUpdatingLocation()
                trackMapView()
            }
            
        } else { // FROM STOP TO START
            setAsStart = true
            locationTimer?.invalidate()
            HomeViewController.currentStartButtonImage = #imageLiteral(resourceName: "start_btn")
            HomeAnimation.homeStopAnimation(self)
            locationArray = []
            HomeViewController.locationManager.pausesLocationUpdatesAutomatically = true
            HomeViewController.locationManager.stopUpdatingLocation()
            configureInitialMapView()
            
        }
    }
    
}

// MARK: - Map Kit View

extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func configureInitialMapView() {
        var coordinate: CLLocationCoordinate2D? = nil
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            while HomeViewController.locationManager.location == nil {
                HomeViewController.locationManager.requestLocation()
            }
            coordinate = HomeViewController.locationManager.location!.coordinate
            mainMap.showsUserLocation = true
        } else { // default location for when location data is not authorized
            coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(exactly: 36.5151)!, CLLocationDegrees(exactly: 127.2385)!)
        }
        let spanValue = MKCoordinateSpan(latitudeDelta: 120, longitudeDelta: 120)
        let locationRegion = MKCoordinateRegion(center: coordinate!, span: spanValue)
        mainMap.mapType = MKMapType.standard
        mainMap.setRegion(locationRegion, animated: true)
        UIView.animate(withDuration: 1) {
            self.mainMap.alpha = 1
        }
    }
    
    func trackMapView() {
        dateFormatter.dateFormat = "yyyy M월 dd일"
        
        HomeViewController.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        HomeViewController.locationManager.distanceFilter = 5 // meters
        HomeViewController.locationManager.pausesLocationUpdatesAutomatically = false
        HomeViewController.locationManager.allowsBackgroundLocationUpdates = true
        mainMap.mapType = MKMapType.standard
        mainMap.showsUserLocation = true
        
        for _ in 1...10 { // wait for accurate location
            HomeViewController.locationManager.requestLocation()
        }
        
        guard let location = HomeViewController.locationManager.location
            else { return }
        
//        while (locationManager.location != nil) {
//            locationManager.requestLocation()
//        }
        
        locationArray.append([location])
        locationTimer = Timer.scheduledTimer(withTimeInterval: refreshRate, repeats: true) { (timer) in
            HomeViewController.locationManager.requestLocation()
            self.setMapRegion(latitude: (HomeViewController.locationManager.location?.coordinate.latitude)!, longitude: (HomeViewController.locationManager.location?.coordinate.longitude)!, delta: 0.001)
        }
        
        UIView.animate(withDuration: 1) {
            self.mainMap.alpha = 1
        }
        
    }
    
    // DID UPDATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last
            else { return }
        guard let currentRoute = locationArray.last
            else { return }
        guard let lastLocation = currentRoute.last
            else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let newDate = dateFormatter.string(from: newLocation.timestamp)
        let lastDate = dateFormatter.string(from: lastLocation.timestamp)
        
        if speedLimit < checkSpeed(lastLocation: lastLocation, newLocation: newLocation) {
            // give user an alert for high speed
            return
        } else {
            if distanceLimit < newLocation.distance(from: lastLocation) {
                setAsStart = true
            }
            if setAsStart { //
                locationArray.append([newLocation])
                let footstep = Footstep(timestamp: newLocation.timestamp, coordinate: newLocation.coordinate, isNewStartingPoint: true)
                JourneyDataManager.collectJourneyData(footstep: footstep)
                setAsStart = false
                
                distance.text = String(format: "%.2f",(HomeViewController.distanceToday)/1000)
                
            } else { // 계속 걷기
                locationArray[locationArray.count - 1].append(newLocation)
                if newDate == lastDate {
                    HomeViewController.distanceToday += newLocation.distance(from: lastLocation)
                } else {
                    HomeViewController.distanceToday = 0
                } // Make distnaceToday '0' if it's newDay
                extendPolyline(lastLocation: lastLocation, newLocation: newLocation)
                let footstep = Footstep(timestamp: newLocation.timestamp, coordinate: newLocation.coordinate, isNewStartingPoint: false)
                JourneyDataManager.collectJourneyData(footstep: footstep)
                
                distance.text = String(format: "%.2f",(HomeViewController.distanceToday)/1000)
            }
        }
    }
    
    func extendPolyline(lastLocation: CLLocation, newLocation: CLLocation) {
        let newLine = MKPolyline(coordinates: [lastLocation.coordinate, newLocation.coordinate], count: 2)
        self.mainMap.addOverlay(newLine)
    }
    
    func setMapRegion(latitude: CLLocationDegrees, longitude: CLLocationDegrees, delta: Double){
        let coordinateLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        mainMap.setRegion(locationRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = UIColor(named: "mainColor")
        polylineView.lineWidth = 10
        return polylineView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func checkSpeed(lastLocation: CLLocation, newLocation: CLLocation) -> Double {
        let timeInterval = newLocation.timestamp.timeIntervalSince(lastLocation.timestamp)
        let distanceInterval = newLocation.distance(from: lastLocation)
        return distanceInterval / timeInterval
    }
}

