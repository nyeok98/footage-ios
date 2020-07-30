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
        if annotation.isKind(of: NearbyAnnotation.self) {
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NearbyAnnotationView.reuseIdentifier) else { fatalError("Cannot create new cell") }
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
    
}
