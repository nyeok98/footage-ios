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
    @IBOutlet weak var youString: UILabel!
    @IBOutlet weak var todayString: UILabel!
    @IBOutlet weak var footString: UILabel!
    @IBOutlet weak var distance: EFCountingLabel!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBAction func questionCircle(_ sender: UIButton) {
    }
    @IBAction func button1(_ sender: UIButton) {
        polyLineColor = "#EADE4Cff"
    }
    @IBAction func button2(_ sender: UIButton) {
        polyLineColor = "#F5A997ff"
    }
    @IBAction func button3(_ sender: UIButton) {
        polyLineColor = "#F0E7CFff"
    }
    @IBAction func button4(_ sender: UIButton) {
        polyLineColor = "#FF6B39ff"
    }
    @IBAction func button5(_ sender: UIButton) {
        polyLineColor = "#206491ff"
    }
    
    /// 2. For MapKit
    static var distanceToday: Double = 0
    static var distanceTotal: Double = 0
    var dateFormatter =  DateFormatter()
    static let locationManager = CLLocationManager()
    var locationsToday: [[CLLocation]] = [[]]
    var locationTimer: Timer?
    var setAsStart: Bool = true
    var speedLimit: Double = 8
    var refreshRate: Double = 2.5
    var distanceLimit: Double {
        get {
            return speedLimit * refreshRate
        }
    }
    var polyLineColor: String = "#EADE4Cff"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegates
        mainMap.delegate = self
        HomeViewController.locationManager.delegate = self
        // start animation
        startButton.setImage(#imageLiteral(resourceName: "startButton"), for: .normal)
        HomeViewController.currentStartButtonImage = startButton.currentImage
        prepareForAnimation()
        HomeAnimation.homeStopAnimation(self)
        configureInitialMapView()
        
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if startButton.currentImage == #imageLiteral(resourceName: "startButton") { // FROM START TO STOP
            HomeViewController.distanceToday = DataManager.loadDistance(total: false)
            HomeViewController.currentStartButtonImage = #imageLiteral(resourceName: "stopButton")
            HomeViewController.locationManager.requestAlwaysAuthorization()
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
                alertForAuthorization()
            } else {
                HomeAnimation.homeStartAnimation(self)
                trackMapView()
            }
            
        } else { // FROM STOP TO START
            locationTimer?.invalidate() // stop location request
            HomeViewController.locationManager.stopUpdatingLocation()
            HomeViewController.locationManager.pausesLocationUpdatesAutomatically = true
            HomeViewController.currentStartButtonImage = #imageLiteral(resourceName: "startButton")
            setAsStart = true // next coordinate must be set as new start point
            // locationsToday = []
            // distance.text = String(format: "%.2f",(HomeViewController.distanceToday)/1000)
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
        for journey in DataManager.loadFromRealm(rangeOf: "all") {
            for route in journey.routes {
                var coordinates: [CLLocationCoordinate2D] = []
                for footstep in route.footsteps {
                    coordinates.append(footstep.coordinate)
                }
                let newLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
                self.mainMap.addOverlay(newLine)
            }
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
        for journey in DataManager.loadFromRealm(rangeOf: today) {
            for route in journey.routes {
                var coordinates: [CLLocationCoordinate2D] = []
                for footstep in route.footsteps {
                    coordinates.append(footstep.coordinate)
                }
                let newLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
                self.mainMap.addOverlay(newLine)
            }
        }
        for _ in 1...10 { // wait for accurate location
            HomeViewController.locationManager.requestLocation()
        }
        guard let location = HomeViewController.locationManager.location
            else { return }
        locationsToday.append([location])
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
        guard let currentRoute = locationsToday.last
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
                locationsToday.append([newLocation])
                let footstep = Footstep(timestamp: newLocation.timestamp, coordinate: newLocation.coordinate, isNewStartingPoint: true, color: polyLineColor)
                DataManager.collectJourneyData(footstep: footstep)
                setAsStart = false
                
                distance.text = String(format: "%.2f",(HomeViewController.distanceToday)/1000)
            } else { // 계속 걷기
                locationsToday[locationsToday.count - 1].append(newLocation)
                if newDate == lastDate {
                    HomeViewController.distanceToday += newLocation.distance(from: lastLocation)
                    HomeViewController.distanceTotal += newLocation.distance(from: lastLocation)
                    print(HomeViewController.distanceTotal) // TEST
                } else { // 여기로 들어올 수 있는경우는 자정에 계속 걷고 있는 경우인데... 그럼 아예 polyline 리셋 해야되나?
                    HomeViewController.distanceToday = 0 // Make distnaceToday '0' if it's newDay
                }
                extendPolyline(lastLocation: lastLocation, newLocation: newLocation)
                let footstep = Footstep(timestamp: newLocation.timestamp, coordinate: newLocation.coordinate, isNewStartingPoint: false, color: polyLineColor)
                DataManager.collectJourneyData(footstep: footstep)
                DataManager.saveTotalDistance(value: HomeViewController.distanceTotal)
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
        polylineView.strokeColor = UIColor(hex: polyLineColor)
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

// MARK: -Others
extension HomeViewController {
    
    func prepareForAnimation() {
        startButton.alpha = 0
        
        distanceView.alpha = 0
        unitLabel.alpha = 0
        
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
