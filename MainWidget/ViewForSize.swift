//
//  ViewForSize.swift
//  footage
//
//  Created by Wootae on 10/11/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import SwiftUI

struct SmallView: View {
    var state: HomeState
    var body: some View {
        Image(uiImage: state.snapshot)
    }
}

struct MediumView: View {
    var state: HomeState
    var body: some View {
        Image(uiImage: state.snapshot)
    }
}
