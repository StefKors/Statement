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

    @State private var isHovering: Bool = false

    var body: some View {
        VStack {
            Map(
                coordinateRegion: .constant(location.region),
                interactionModes: [],
                annotationItems: [location]
            ) {
                MapMarker(coordinate: $0.coordinate, tint: Color.yellow)
            }
            .edgesIgnoringSafeArea(.all)
            .cornerRadius(4)
            .frame(height: 120)
            .allowsHitTesting(false)
        }
        .overlay(content: {
            ZStack {
                Color.windowBackgroundColor.opacity(isHovering ? 0.4 : 0)
                if isHovering {
                    Image(systemName: "map.fill")
                        .imageScale(.large)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .onHover(perform: { hoverState in
                withAnimation(.interpolatingSpring(stiffness: 300, damping: 20)) {
                    isHovering = hoverState
                }
            })
            .onTapGesture {
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: location.region.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: location.region.span)
                ]
                let placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.openInMaps(launchOptions: options)
            }
        })
    }
}

struct MapPinView_Previews: PreviewProvider {
    static var previews: some View {
        MapPinView(location: .preview)
    }
}
