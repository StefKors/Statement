//
//  MapPinView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//  based on: https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-annotations-in-a-map-view

import SwiftUI
import MapKit

struct MapPinView: View {
    let location: MapLocation

    var body: some View {
        Map(
            coordinateRegion: .constant(location.region),
            interactionModes: [],
            annotationItems: [location]
        ) {
            MapMarker(coordinate: $0.coordinate, tint: Color.accentColor)
        }
        .edgesIgnoringSafeArea(.all)
        .cornerRadius(4)
        .frame(height: 120)
    }
}

struct MapPinView_Previews: PreviewProvider {
    static var previews: some View {
        MapPinView(location: .preview)
    }
}
