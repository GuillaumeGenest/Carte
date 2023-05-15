//
//  Map.swift
//  Map
//
//  Created by Paul Kraft on 22.04.22.
//

import MapKit
import SwiftUI
import UIKit

public struct Carte<AnnotationItems: RandomAccessCollection>
    where AnnotationItems.Element: Identifiable{

    // MARK: Stored Properties

    @Binding var coordinateRegion: MKCoordinateRegion
    @Binding var mapRect: MKMapRect

    let usesRegion: Bool

    let mapType: MKMapType
    let pointOfInterestFilter: MKPointOfInterestFilter?

    let informationVisibility: MapInformationVisibility
    let interactionModes: MapInteractionModes

    let usesUserTrackingMode: Bool
    @Binding var userTrackingMode: UserTrackingMode

    let annotationItems: AnnotationItems
    let annotationContent: (AnnotationItems.Element) -> MapAnnotation
    let clusterAnnotation: (MKClusterAnnotation, [AnnotationItems.Element]) -> MapAnnotation?

//    let overlayItems: OverlayItems
//    let overlayContent: (OverlayItems.Element) -> MapOverlay

}

// MARK: - Initialization

extension Carte {

    public init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        type mapType: MKMapType = .standard,
        pointOfInterestFilter: MKPointOfInterestFilter? = nil,
        informationVisibility: MapInformationVisibility = .default,
        interactionModes: MapInteractionModes = .all,
        userTrackingMode: Binding<UserTrackingMode>? = nil,
        annotationItems: AnnotationItems,
        @MapAnnotationBuilder annotationContent: @escaping (AnnotationItems.Element) -> MapAnnotation,
        @OptionalMapAnnotationBuilder clusterAnnotation: @escaping (MKClusterAnnotation, [AnnotationItems.Element]) -> MapAnnotation? = { _, _ in nil }
//        overlayItems: OverlayItems,
//        @MapOverlayBuilder overlayContent: @escaping (OverlayItems.Element) -> MapOverlay
    ) {
        self.usesRegion = true
        self._coordinateRegion = coordinateRegion
        self._mapRect = .constant(.init())
        self.mapType = mapType
        self.pointOfInterestFilter = pointOfInterestFilter
        self.informationVisibility = informationVisibility
        self.interactionModes = interactionModes
        if let userTrackingMode = userTrackingMode {
            self.usesUserTrackingMode = true
            self._userTrackingMode = userTrackingMode
        } else {
            self.usesUserTrackingMode = false
            self._userTrackingMode = .constant(.none)
        }
        self.annotationItems = annotationItems
        self.annotationContent = annotationContent
        self.clusterAnnotation = clusterAnnotation
//        self.overlayItems = overlayItems
//        self.overlayContent = overlayContent
    }

    public init(
        mapRect: Binding<MKMapRect>,
        type mapType: MKMapType = .standard,
        pointOfInterestFilter: MKPointOfInterestFilter? = nil,
        informationVisibility: MapInformationVisibility = .default,
        interactionModes: MapInteractionModes = .all,
        userTrackingMode: Binding<UserTrackingMode>? = nil,
        annotationItems: AnnotationItems,
        @MapAnnotationBuilder annotationContent: @escaping (AnnotationItems.Element) -> MapAnnotation,
        @OptionalMapAnnotationBuilder clusterAnnotation: @escaping (MKClusterAnnotation, [AnnotationItems.Element]) -> MapAnnotation? = { _, _ in nil }
//        overlayItems: OverlayItems,
//        @MapOverlayBuilder overlayContent: @escaping (OverlayItems.Element) -> MapOverlay
    ) {
        self.usesRegion = false
        self._coordinateRegion = .constant(.init())
        self._mapRect = mapRect
        self.mapType = mapType
        self.pointOfInterestFilter = pointOfInterestFilter
        self.informationVisibility = informationVisibility
        self.interactionModes = interactionModes
        if let userTrackingMode = userTrackingMode {
            self.usesUserTrackingMode = true
            self._userTrackingMode = userTrackingMode
        } else {
            self.usesUserTrackingMode = false
            self._userTrackingMode = .constant(.none)
        }
        self.annotationItems = annotationItems
        self.annotationContent = annotationContent
        self.clusterAnnotation = clusterAnnotation
//        self.overlayItems = overlayItems
//        self.overlayContent = overlayContent
    }

}



// MARK: - AnnotationItems == [IdentifiableObject<MKAnnotation>]

// The following initializers are most useful for either bridging with old MapKit code for annotations
// or to actually not use annotations entirely.



extension Carte where AnnotationItems == [IdentifiableObject<MKAnnotation>] {

    public init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        type mapType: MKMapType = .standard,
        pointOfInterestFilter: MKPointOfInterestFilter? = nil,
        informationVisibility: MapInformationVisibility = .default,
        interactionModes: MapInteractionModes = .all,
        userTrackingMode: Binding<UserTrackingMode>? = nil,
        annotations: [MKAnnotation] = [],
        @MapAnnotationBuilder annotationContent: @escaping (MKAnnotation) -> MapAnnotation = { annotation in
            assertionFailure("Please provide an `annotationContent` closure for the values in `annotations`.")
            return CarteAnnotation(annotation: annotation) {}
        },
        @OptionalMapAnnotationBuilder clusterAnnotation: @escaping (MKClusterAnnotation) -> MapAnnotation? = { _ in nil }
//        overlayItems: OverlayItems,
//        @MapOverlayBuilder overlayContent: @escaping (OverlayItems.Element) -> MapOverlay
    ) {
        self.init(
            coordinateRegion: coordinateRegion,
            type: mapType,
            pointOfInterestFilter: pointOfInterestFilter,
            informationVisibility: informationVisibility,
            interactionModes: interactionModes,
            userTrackingMode: userTrackingMode,
            annotationItems: annotations.map(IdentifiableObject.init),
            annotationContent: { annotationContent($0.object) },
            clusterAnnotation: { annotation, _ in clusterAnnotation(annotation) }
//            overlayItems: overlayItems,
//            overlayContent: overlayContent
        )
    }

    public init(
        mapRect: Binding<MKMapRect>,
        type mapType: MKMapType = .standard,
        pointOfInterestFilter: MKPointOfInterestFilter? = nil,
        informationVisibility: MapInformationVisibility = .default,
        interactionModes: MapInteractionModes = .all,
        userTrackingMode: Binding<UserTrackingMode>? = nil,
        annotations: [MKAnnotation] = [],
        @MapAnnotationBuilder annotationContent: @escaping (MKAnnotation) -> MapAnnotation = { annotation in
            assertionFailure("Please provide an `annotationContent` closure for the values in `annotations`.")
            return CarteAnnotation(annotation: annotation) {}
        },
        @OptionalMapAnnotationBuilder clusterAnnotation: @escaping (MKClusterAnnotation) -> MapAnnotation? = { _ in nil }
//        overlayItems: OverlayItems,
//        @MapOverlayBuilder overlayContent: @escaping (OverlayItems.Element) -> MapOverlay
    ) {
        self.init(
            mapRect: mapRect,
            type: mapType,
            pointOfInterestFilter: pointOfInterestFilter,
            informationVisibility: informationVisibility,
            interactionModes: interactionModes,
            userTrackingMode: userTrackingMode,
            annotationItems: annotations.map(IdentifiableObject.init),
            annotationContent: { annotationContent($0.object) },
            clusterAnnotation: { annotation, _ in clusterAnnotation(annotation) }
//            overlayItems: overlayItems,
//            overlayContent: overlayContent
        )

    }

}
