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
    
    let locationManager = CLLocationManager()
    var locationArray: [CLLocation] = []
    var journeyData: JourneyData? = nil
    static var distanceToday: Double = 0
    
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
        locationManager.delegate = self
        startButton.setImage(#imageLiteral(resourceName: "start_btn"), for: .normal)
        setInitialAlpha()
        setInitialPositionTriangle()
        configureInitialMapView()
        HomeAnimation.homeStopAnimation(self)
        //drawDirection()
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
        
        //let homeAnimation = HomeAnimation()
        
        if startButton.currentImage == #imageLiteral(resourceName: "start_btn") {
            HomeAnimation.homeStartAnimation(self)
            UIView.animate(withDuration: 1) {
                self.mainMap.alpha = 0
            }
            locationManager.requestWhenInUseAuthorization() // 사용자 인증 요청
            locationManager.requestLocation()
            let originalLocation = locationManager.location!
            var newLocation = locationManager.location
            for _ in 1...10 {
                self.locationManager.requestLocation()
                newLocation = self.locationManager.location
            }
            trackMapView()
        } else {
            HomeAnimation.homeStopAnimation(self)
            StatsViewController.journeyArray.append(journeyData!)
            print(journeyData!.coordinateArray[0])
            UIView.animate(withDuration: 1) {
                self.mainMap.alpha = 0
            }
            locationManager.stopUpdatingLocation()
            locationManager.pausesLocationUpdatesAutomatically = true
            configureInitialMapView()
        }
    }
    
}

// MARK: Map Kit View

extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func configureInitialMapView() {
        mainMap.mapType = MKMapType.satelliteFlyover
        let coordinateLocation = CLLocationCoordinate2DMake(CLLocationDegrees(exactly: 37.3341)!, CLLocationDegrees(exactly:-122.0092)!)
        let spanValue = MKCoordinateSpan(latitudeDelta: 120, longitudeDelta: 120)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        mainMap.setRegion(locationRegion, animated: true)
        UIView.animate(withDuration: 1) {
            self.mainMap.alpha = 1
        }
    }
    
    func trackMapView() {
        //지도 띄우기
        // Do any additional setup after loading the view, typically from a nib.
        journeyData = JourneyData()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//정확도 최고
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            self.locationManager.requestLocation()
        }
        locationArray.append(locationManager.location!) // 위치 업데이트 시작
        //locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 5 // meters
        locationManager.pausesLocationUpdatesAutomatically = true
        mainMap.mapType = MKMapType.standard
        mainMap.showsUserLocation = true // 현재 위치에 마커로 표시됨
        UIView.animate(withDuration: 1) {
            self.mainMap.alpha = 1
        }
        myLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, delta: 0.001)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func myLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, delta: Double){
        let coordinateLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        mainMap.setRegion(locationRegion, animated: true)
    }
    
    //업데이트 되는 위치정보 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update called")
        guard let lastLocation = locations.last //가장 최근의 위치정보 저장
            else { return }
        locationArray.append(lastLocation)
        journeyData!.coordinateArray.append(lastLocation.coordinate)
        appendNewDirection()
        myLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude, delta: 0.001) // 0.01은 100배확대
    }
    
    func appendNewDirection() {
       let timeInterval = locationArray[locationArray.count - 1].timestamp.timeIntervalSince(locationArray[locationArray.count - 2].timestamp)
        print(timeInterval)
        
        let lastLocation = locationArray[locationArray.count - 2]
        let newLocation = locationArray[locationArray.count - 1]
        HomeViewController.distanceToday += newLocation.distance(from: lastLocation)
         self.distance.text = String(format: "%.2f", HomeViewController.distanceToday / 1000)
        let newLine = MKPolyline(coordinates: [lastLocation.coordinate, newLocation.coordinate], count: 2)
        
        let distanceInterval = newLocation.distance(from: lastLocation)
        
        if distanceInterval/timeInterval < 7 {
            print(distanceInterval/timeInterval)
            self.mainMap.addOverlay(newLine)
        } else {
            print(distanceInterval/timeInterval)
            return
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = UIColor(named: "mainColor")
        polylineView.lineWidth = 10
        return polylineView
    }
}


