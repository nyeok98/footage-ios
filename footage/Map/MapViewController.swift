//
//  MapViewController.swift
//  footage
//
//  Created by Wootae on 7/28/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MapViewController: UIViewController {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    var preventTableUpdate = false // to prevent table from reloading when collectionview is showing / view is resizing
    var currentLocation: CLLocationCoordinate2D! = nil
    var allFootsteps: [Footstep] = []
    
    override func viewDidLoad() {
        M.mapVC = self
        super.viewDidLoad()
        getCurrentLocation()
        initializeMapView()
        M.tableVC.reloadWithNewLocation(coordinate: currentLocation, selected: nil)
        addChild(M.bottomVC)
        view.addSubview(M.bottomVC.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        allFootsteps = Array(realm.objects(Footstep.self)).filter({(footstep) -> Bool in !footstep.notes.isEmpty })
        M.tableVC.allFootsteps = allFootsteps
        M.tableVC.reloadWithNewLocation(coordinate: currentLocation, selected: nil)
    }
    
    @objc func getCurrentLocation() {
        while locationManager.location == nil {
            locationManager.requestLocation()
        }
        currentLocation = locationManager.location!.coordinate
        mapView.setCenter(currentLocation, animated: false)
    }
    
    func initializeMapView() { // mapView configuration and add all annotations
        mapView.showsUserLocation = true
        mapView.delegate = self
        K.contentHeight = K.screenHeight - (tabBarController?.tabBar.bounds.height)!
        mapView.frame = CGRect(x: 0, y: K.contentHeight / -2, width: K.screenWidth, height: K.contentHeight * 2)
        let camera = MKMapCamera(lookingAtCenter: currentLocation, fromDistance: CLLocationDistance(exactly: 500000)!, pitch: 0, heading: CLLocationDirection(exactly: 0)!)
        mapView.setCamera(camera, animated: false)
        
        let realm = try! Realm()
        allFootsteps = Array(realm.objects(Footstep.self)).filter({(footstep) -> Bool in !footstep.notes.isEmpty })
        M.tableVC.allFootsteps = allFootsteps
        mapView.register(NearbyAnnotationView.self, forAnnotationViewWithReuseIdentifier: NearbyAnnotationView.reuseIdentifier)
        mapView.register(AppleClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        let annotations = allFootsteps.map { (footstep) -> NearbyAnnotation in
            return NearbyAnnotation(footstep: footstep, distance: 0)
        }
        mapView.addAnnotations(annotations)
        view.addSubview(mapView)
        
        let locationButton = UIButton(frame: CGRect(x: 10, y: 40, width: 45, height: 45))
        locationButton.setImage(#imageLiteral(resourceName: "myLocation"), for: .normal)
        locationButton.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        view.addSubview(locationButton)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let cluster = annotation as? MKClusterAnnotation {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "cluster") as? AppleClusterAnnotationView
            if view == nil {
                view = AppleClusterAnnotationView(annotation: cluster, reuseIdentifier: "cluster")
            }
            return view
        }
        
        if annotation.isKind(of: NearbyAnnotation.self) {
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NearbyAnnotationView.reuseIdentifier) else { fatalError("Cannot create new annotation") }
            return annotationView
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? NearbyAnnotation else { return }
        guard let footstep = annotation.footstep else { return }
        mapView.setCenter(footstep.coordinate, animated: true)
        M.bottomVC.reloadSelectedView(selected: footstep)
        M.tableVC.reloadWithNewLocation(coordinate: footstep.coordinate, selected: footstep)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !animated && !preventTableUpdate {
            M.bottomVC.reloadSelectedView(selected: nil)
            M.tableVC.reloadWithNewLocation(coordinate: mapView.centerCoordinate, selected: nil)
        }
    }
}

class NearbyAnnotation: MKPointAnnotation {
    
    var footstep: Footstep! = nil
    var distance = 0.0
    
    init(footstep: Footstep, distance: Double) {
        super.init()
        self.coordinate = footstep.coordinate
        self.footstep = footstep
        self.distance = distance
    }
}

class NearbyAnnotationView: MKAnnotationView {
    
    static let reuseIdentifier = "nearby-reuse"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true
        self.isEnabled = true
        self.image = #imageLiteral(resourceName: "pin")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "ClusteredAnnotation"
        }
    }
}

class AppleClusterAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultLow
        //collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
                let count = cluster.memberAnnotations.count
                image = renderer.image { _ in
                    // Fill inner circle with white color
                    UIColor.white.setFill()
                    UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 50, height: 50)).fill()
                    
                    // Finally draw count text vertically and horizontally centered
                    let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                                       NSAttributedString.Key.font: UIFont(name: "NanumBarunPen-Bold", size: 20)]
                    let text = "\(count)"
                    let size = text.size(withAttributes: attributes as [NSAttributedString.Key : Any])
                    let rect = CGRect(x: 33 - size.width / 2, y: 33 - size.height / 2, width: size.width, height: size.height)
                    text.draw(in: rect, withAttributes: attributes as [NSAttributedString.Key : Any])
                }
            }
        }
    }
    
    
    
}
