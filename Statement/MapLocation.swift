//
//  MapLocation.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: self.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
}

extension MapLocation {
    static let preview = MapLocation(latitude: 51.507222, longitude: -0.1275)
}
