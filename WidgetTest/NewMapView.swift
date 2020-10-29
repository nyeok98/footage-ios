//
//  NewMapView.swift
//  footage
//
//  Created by Wootae on 10/4/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import SwiftUI
import MapKit

struct NewMapView: View {
    
    @Binding var region: MKCoordinateRegion
    
    var body: some View {
        Map(coordinateRegion: $region)
    }
}
