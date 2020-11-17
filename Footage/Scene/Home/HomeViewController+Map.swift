//
//  HomeViewController+Map.swift
//  Footage
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit
import MapKit

extension HomeViewController: MKMapViewDelegate {
    func setupMapView() {
        mainMap.mapType = MKMapType.standard
        mainMap.showsUserLocation = true
        UIView.animate(withDuration: 1) { self.mainMap.alpha = 1 }
    }
    
    func setInitialCoordinate() {
        let coordinate: CLLocationCoordinate2D
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            while locationManager.location == nil {
                locationManager.requestLocation()
            }
            coordinate = locationManager.location!.coordinate
        } else { // default location for when location data is not authorized
            coordinate = CLLocationCoordinate2DMake(
                CLLocationDegrees(exactly: 36.5151)!, CLLocationDegrees(exactly: 127.2385)!)
        }
        let spanValue = MKCoordinateSpan(latitudeDelta: 120, longitudeDelta: 120)
        let locationRegion = MKCoordinateRegion(center: coordinate, span: spanValue)
        mainMap.setRegion(locationRegion, animated: true)
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        <#code#>
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        <#code#>
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlayWithColor = overlay as? PolylineWithColor {
            let polylineView = MKPolylineRenderer(overlay: overlay)
            polylineView.strokeColor = overlayWithColor.color
            polylineView.lineWidth = 8
            return polylineView
        } else {
            let polylineView = MKPolylineRenderer(overlay: overlay)
            polylineView.strokeColor = UIColor(hex: HomeViewController.selectedColor)
            polylineView.lineWidth = 8
            return polylineView
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
}
