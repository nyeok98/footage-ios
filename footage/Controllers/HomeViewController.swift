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
        startButton.setImage(#imageLiteral(resourceName: "start_btn"), for: .normal)
        setInitialAlpha()
        setInitialPositionTriangle()
        HomeAnimation.homeStopAnimation(self)
        drawDirection()
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
        } else {
            HomeAnimation.homeStopAnimation(self)
        }
    }
    
}

// MARK: Map Kit View

extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func configureMapView() {
        let locationManager = CLLocationManager()//지도 띄우기
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //정확도 최고
        locationManager.requestWhenInUseAuthorization() //사용자 인증 요청
        locationManager.startUpdatingLocation() //위치 업데이트 시작
        mainMap.showsUserLocation = true //현재 위치에 마커로 표시됨
        
    }
    
    
    func myLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, delta: Double){
        let coordinateLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        mainMap.setRegion(locationRegion, animated: true)
        
    }
    
    //업데이트 되는 위치정보 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last //가장 최근의 위치정보 저장
        myLocation(latitude: (lastLocation?.coordinate.latitude)!, longitude: (lastLocation?.coordinate.longitude)!, delta: 0.01) //delat값이 1보다 작을수록 확대됨. 0.01은 100배확대
        
    }
    
    func drawDirection() {
        let start = MKPlacemark(coordinate:
            CLLocationCoordinate2D(latitude: 36.5150, longitude: 127.2384))
        let finish = MKPlacemark(coordinate:
            CLLocationCoordinate2D(latitude: 36.5150, longitude: 128))
        let direction = MKDirections.Request()
        direction.source = MKMapItem(placemark: start)
        direction.destination = MKMapItem(placemark: finish)
        direction.transportType = .walking
        let directions = MKDirections(request: direction)
        directions.calculate { (response, error) in
            guard let response = response else {
                return
            }
            let route = response.routes[0]
            print(route.steps[0].instructions)
            self.mainMap.addOverlay(route.polyline)
//            let originalFrame = route.polyline.boundingMapRect
//            let mapFrame = MKMapRect(x: originalFrame.origin.x-100, y: originalFrame.origin.y-100, width: originalFrame.width + 100, height: originalFrame.height + 100)
            self.mainMap.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = UIColor(named: "tabColor")
        return polylineView
    }
    
    
}


