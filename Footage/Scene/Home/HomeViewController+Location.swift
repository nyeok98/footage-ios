//
//  HomeViewController+Location.swift
//  Footage
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import Foundation
import MapKit

extension HomeViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5 // meters
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .fitness
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        nextLocation = locations[0]
        checkForMovement(location: nextLocation)
        guard let nextLocation = nextLocation else { return }
        guard let lastLocation = lastLocation else { return }
        if isValid(location: nextLocation) {
            if setAsStart { // now began to walk
                saveStart = nextLocation
                setAsStart = false
            } else { // continue walking
                if let startLocation = saveStart {
                    LocationUpdate.processNewLocation(location: startLocation, distance: 0, setAsStart: true, color: HomeViewController.selectedColor)
                    saveStart = nil
                }
                let newDistance = nextLocation.distance(from: lastLocation)
                LocationUpdate.processNewLocation(location: nextLocation, distance: newDistance, setAsStart: false, color: HomeViewController.selectedColor)
                self.extendPolyline(lastLocation: lastLocation, newLocation: nextLocation)
                HomeViewController.distanceToday += newDistance
                distance.text = String(format: "%.2f", (HomeViewController.distanceToday) / 1000)
                HomeViewController.distanceTotal += newDistance
                BadgeGiver.checkDistance(view: view)
                BadgeGiver.cityCheck(view: view)
                DateManager.saveTotalDistance(value: HomeViewController.distanceTotal)
            }
        } else { setAsStart = true } // you are on a bus
        self.lastLocation = nextLocation
        mainMap.setCenter(nextLocation.coordinate, animated: true)
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        HomeViewController.currentStartButtonImage = #imageLiteral(resourceName: "startButton")
        setAsStart = true // next coordinate must be set as new start point
        HomeAnimation.homeStopAnimation(self)
        setupMapView()
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        HomeAnimation.homeStartAnimation(self)
        trackMapView()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
