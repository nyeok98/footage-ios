//
//  MapView.swift
//  footage
//
//  Created by Wootae on 10/4/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    
    @State var center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37, longitude: 137)
    
    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            parent.center = locations[0].coordinate
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setCenter(CLLocationCoordinate2DMake(37, 137), animated: false)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setCenter(center, animated: true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
