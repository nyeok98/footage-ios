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
    
    // VARIABLES
    /// 1. For Home Animation
    static var currentStartButtonImage: UIImage?
    @IBOutlet weak var mainMap: MKMapView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var StringStackView: UIStackView!
    @IBOutlet weak var youString: UILabel!
    @IBOutlet weak var todayString: UILabel!
    @IBOutlet weak var footString: UILabel!
    @IBOutlet weak var startAboutStackView: UIStackView!
    @IBOutlet weak var distance: EFCountingLabel!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var selectedButtonLabel: UILabel!
    @IBOutlet weak var exampleImageView: UIImageView!
    @IBAction func questionCircle(_ sender: UIButton) {
        exampleImageView.isHidden = true
    }
    @IBAction func questionCirclePressed(_ sender: UIButton) {
        exampleImageView.isHidden = false
        UIApplication.shared.keyWindow!.addSubview(exampleImageView)
        UIApplication.shared.keyWindow!.bringSubviewToFront(exampleImageView)
    }
    @IBOutlet weak var currentColorIndicator: UIImageView!
    @IBOutlet weak var selectedButtonStackView: UIStackView!
    @IBOutlet weak var MainButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fifthButton: UIButton!
    
    @IBAction func secondButtonPressed(_ sender: UIButton) {
        HomeAnimation.buttonChanger(homeVC: self, pressedbutton: sender)
        HomeAnimation.colorSelected(homeVC: self, pressedbutton: sender)
    }
    @IBAction func thirdButtonPressed(_ sender: UIButton) {
        HomeAnimation.buttonChanger(homeVC: self, pressedbutton: sender)
        HomeAnimation.colorSelected(homeVC: self, pressedbutton: sender)
    }
    @IBAction func fourthButtonPressed(_ sender: UIButton) {
        HomeAnimation.buttonChanger(homeVC: self, pressedbutton: sender)
        HomeAnimation.colorSelected(homeVC: self, pressedbutton: sender)
    }
    @IBAction func fifthButtonPressed(_ sender: UIButton) {
        HomeAnimation.buttonChanger(homeVC: self, pressedbutton: sender)
        HomeAnimation.colorSelected(homeVC: self, pressedbutton: sender)
    }
    
    /// 2. For MapKit
    static var distanceToday: Double = 0
    static var distanceTotal: Double = 0
    var dateFormatter =  DateFormatter()
    static let locationManager = CLLocationManager()
     var locations: [CLLocation] = []
    var lastLocation: CLLocation?
    var locationTimer: Timer?
    var setAsStart: Bool = true
    var speedLimit: Double = 10
    var refreshRate: Double = 2.5
    var distanceLimit: Double {
        get {
            return speedLimit * refreshRate
        }
    }
    static var selectedColor: String = "#EADE4Cff"
    var speedCounter: Int = 0
    var noSpeedCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exampleImageView.isHidden = true
        // set delegates
        mainMap.delegate = self
        HomeViewController.locationManager.delegate = self
        // start animation
        startButton.setImage(#imageLiteral(resourceName: "startButton"), for: .normal)
        HomeViewController.currentStartButtonImage = startButton.currentImage
        selectedButtonLabel.text = UserDefaults.standard.string(forKey: "#EADE4Cff")
        mainMap.tintColor = UIColor(hex: "#EADE4Cff")
        prepareForAnimation()
        HomeAnimation.homeStopAnimation(self)
        configureInitialMapView()
        
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "startedBefore") == false {
            UserDefaults.standard.setValue(true, forKey: "startedBefore")
            LevelManager.firstLaunch()
        } else {
            
        }
        if startButton.currentImage == #imageLiteral(resourceName: "startButton") { // FROM START TO STOP
            HomeViewController.distanceToday = DateManager.loadDistance(total: false)
            HomeViewController.currentStartButtonImage = #imageLiteral(resourceName: "stopButton")
            HomeViewController.locationManager.requestAlwaysAuthorization()
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined || status == .denied {
                alertForAuthorization()
            } else {
                HomeAnimation.homeStartAnimation(self)
                HomeViewController.selectedColor = Buttons(className: MainButton.restorationIdentifier!).color
                trackMapView()
            }
            
        } else { // FROM STOP TO START
            locationTimer?.invalidate() // stop location request
            HomeViewController.locationManager.stopUpdatingLocation()
            HomeViewController.locationManager.pausesLocationUpdatesAutomatically = true
            HomeViewController.currentStartButtonImage = #imageLiteral(resourceName: "startButton")
            setAsStart = true // next coordinate must be set as new start point
            HomeAnimation.homeStopAnimation(self)
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
        // draw all routes
        for journey in DateManager.loadFromRealm(rangeOf: "year") {
            DrawOnMap.polylineFromFootsteps(journey.footsteps, on: mainMap)
        }
        UIView.animate(withDuration: 1) {
            self.mainMap.alpha = 1
        }
    }
    
    func trackMapView() {
        dateFormatter.dateFormat = "yyyyMMdd"
        let today = dateFormatter.string(from: Date())
        HomeViewController.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        HomeViewController.locationManager.distanceFilter = 5 // meters
        HomeViewController.locationManager.pausesLocationUpdatesAutomatically = false
        HomeViewController.locationManager.allowsBackgroundLocationUpdates = true
        mainMap.mapType = MKMapType.standard
        mainMap.showsUserLocation = true
        // draw previous routes from today
        for journey in DateManager.loadFromRealm(rangeOf: today) {
            DrawOnMap.polylineFromFootsteps(journey.footsteps, on: mainMap)
        }
        for _ in 1...10 { // wait for accurate location
            HomeViewController.locationManager.requestLocation()
        }
        guard let location = HomeViewController.locationManager.location
            else { return }
        lastLocation = location
        locationTimer = Timer.scheduledTimer(withTimeInterval: refreshRate, repeats: true) { (timer) in
            HomeViewController.locationManager.requestLocation() // request location and move to center every 5 sec
            self.setMapRegion(latitude: (HomeViewController.locationManager.location?.coordinate.latitude)!, longitude: (HomeViewController.locationManager.location?.coordinate.longitude)!, delta: 0.001)
        }
        UIView.animate(withDuration: 1) {
            self.mainMap.alpha = 1
        }
    }
    
    // DID UPDATE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations[0]
        checkForMovement(location: newLocation)
        if isValid(location: newLocation) {
            if setAsStart { // now began to walk
                LocationUpdate.processNewLocation(location: newLocation, distance: 0, setAsStart: true, color: HomeViewController.selectedColor)
                setAsStart = false
            } else { // continue walking
                let newDistance = newLocation.distance(from: lastLocation!)
                LocationUpdate.processNewLocation(location: newLocation, distance: newDistance, setAsStart: false, color: HomeViewController.selectedColor)
                extendPolyline(lastLocation: lastLocation!, newLocation: newLocation)
                HomeViewController.distanceToday += newDistance
                distance.text = String(format: "%.2f", (HomeViewController.distanceToday)/1000)
                HomeViewController.distanceTotal += newDistance
                BadgeGiver.checkDistance()
                DateManager.saveTotalDistance(value: HomeViewController.distanceTotal)
            }
        } else { setAsStart = true } // you are on a bus
        lastLocation = newLocation
        
    }
    
    func isValid(location: CLLocation) -> Bool { // check speed, distance etc with lastLocation
        if checkSpeed(lastLocation: lastLocation ?? location, newLocation: location) > speedLimit || location.distance(from: lastLocation ?? location) > distanceLimit {
            return false
        } else if location.speed < 0 && lastLocation!.speed < 0 { return false }
        else { noSpeedCounter = 0; return true }
    }
    
    func checkForMovement(location: CLLocation) {
        
        print(location.speed)
        print(noSpeedCounter)
        
        if location.speed > speedLimit { speedCounter += 1 }
        
        if location.speed < 0 { noSpeedCounter += 1 }
        else { noSpeedCounter = 0 }

        if speedCounter > 4 || noSpeedCounter > 10 {
            locationTimer?.invalidate() // stop location request
            HomeViewController.locationManager.stopUpdatingLocation()
            HomeViewController.locationManager.pausesLocationUpdatesAutomatically = true
            HomeViewController.currentStartButtonImage = #imageLiteral(resourceName: "startButton")
            setAsStart = true // next coordinate must be set as new start point
            HomeAnimation.homeStopAnimation(self)
            configureInitialMapView()
            speedCounter = 0
        }
    }
    
    func extendPolyline(lastLocation: CLLocation, newLocation: CLLocation) {
        let newLine = MKPolyline(coordinates: [lastLocation.coordinate, newLocation.coordinate], count: 2)
        self.mainMap.addOverlay(newLine)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlayWithColor = overlay as? PolylineWithColor {
            let polylineView = MKPolylineRenderer(overlay: overlay)
            polylineView.strokeColor = overlayWithColor.color
            polylineView.lineWidth = 10
            return polylineView
        } else {
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = UIColor(hex: HomeViewController.selectedColor)
        polylineView.lineWidth = 10
        return polylineView
        }
    }
    
    func setMapRegion(latitude: CLLocationDegrees, longitude: CLLocationDegrees, delta: Double){
        let coordinateLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        mainMap.setRegion(locationRegion, animated: true)
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

// MARK: -Others
extension HomeViewController {
    
    func prepareForAnimation() {
        startButton.alpha = 0
        distanceView.alpha = 0
        unitLabel.alpha = 0
        todayString.font = todayString.font.withSize(0.043 * HomeAnimation.screenHeight)
        youString.font = youString.font.withSize(0.043 * HomeAnimation.screenHeight)
        footString.font = footString.font.withSize(0.043 * HomeAnimation.screenHeight)
        unitLabel.font = unitLabel.font.withSize(0.061 * HomeAnimation.screenHeight)
        distance.font = distance.font.withSize(0.08 * HomeAnimation.screenHeight)
        self.view.bringSubviewToFront(StringStackView)
        self.view.bringSubviewToFront(startAboutStackView)
        
    }
    
    func alertForAuthorization() { // present an alert indicating location authorization required
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
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
