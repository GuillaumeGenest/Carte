//
//  View.swift
//  Carte
//
//  Created by Guillaume Genest on 15/05/2023.
//

import Foundation


#if !os(tvOS) && !os(watchOS)

import SwiftUI
import MapKit

@available(macOS 11, *)
public struct MapCompass {

    // MARK: Nested Types

    public class Coordinator {

        // MARK: Stored Properties

        private var view: MapCompass?

        // MARK: Methods

        func update(_ compassButton: MKCompassButton, with newView: MapCompass, context: Context) {
            defer { view = newView }

            if view?.visibility != newView.visibility {
                compassButton.compassVisibility = newView.visibility
            }
        }

    }

    // MARK: Stored Properties

    private let key: AnyHashable
    private let visibility: MKFeatureVisibility

    // MARK: Initialization

    public init<Key: Hashable>(key: Key, visibility: MKFeatureVisibility) {
        self.key = key
        self.visibility = visibility
    }

    // MARK: Methods

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

}

#if canImport(UIKit)

@available(macOS 11, *)
extension MapCompass: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKCompassButton {
        let view = MKCompassButton(mapView: MapRegistry[key])
        updateUIView(view, context: context)
        return view
    }

    public func updateUIView(_ compassButton: MKCompassButton, context: Context) {
        if let mapView = MapRegistry[key], mapView != compassButton.mapView {
            compassButton.mapView = mapView
        }
        context.coordinator.update(compassButton, with: self, context: context)
    }

}

#elseif canImport(AppKit)

@available(macOS 11, *)
extension MapCompass: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKCompassButton {
        let view = MKCompassButton(mapView: MapRegistry[key])
        updateNSView(view, context: context)
        return view
    }

    public func updateNSView(_ compassButton: MKCompassButton, context: Context) {
        if let mapView = MapRegistry[key], mapView != compassButton.mapView {
            compassButton.mapView = mapView
        }
        context.coordinator.update(compassButton, with: self, context: context)
    }

}

#endif

#endif

//
//  MapPitchControl.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if os(macOS) || targetEnvironment(macCatalyst)

import SwiftUI
import MapKit

@available(macCatalyst 14, macOS 11, *)
public struct MapPitchControl {

    // MARK: Stored Properties

    private let key: AnyHashable

    // MARK: Initialization

    public init<Key: Hashable>(key: Key) {
        self.key = key
    }

}

#endif

// MARK: - UIViewRepresentable

#if targetEnvironment(macCatalyst)

@available(macCatalyst 14, *)
extension MapPitchControl: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKPitchControl {
        let view = MKPitchControl(mapView: MapRegistry[key])
        updateUIView(view, context: context)
        return view
    }

    public func updateUIView(_ pitchControl: MKPitchControl, context: Context) {
        if let mapView = MapRegistry[key], mapView != pitchControl.mapView {
            pitchControl.mapView = mapView
        }
    }

}

#endif

// MARK: - NSViewRepresentable

#if os(macOS)

@available(macOS 11, *)
extension MapPitchControl: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKPitchControl {
        let view = MKPitchControl(mapView: MapRegistry[key])
        updateNSView(view, context: context)
        return view
    }

    public func updateNSView(_ pitchControl: MKPitchControl, context: Context) {
        if let mapView = MapRegistry[key], mapView != pitchControl.mapView {
            pitchControl.mapView = mapView
        }
    }

}

#endif

//
//  MapScale.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if canImport(UIKit) && !os(watchOS)

import SwiftUI
import MapKit

public struct MapScale {

    // MARK: Nested Types

    public class Coordinator {

        // MARK: Stored Properties

        private var view: MapScale?

        // MARK: Methods

        func update(_ scaleView: MKScaleView, with newView: MapScale, context: Context) {
            defer { view = newView }

            if view?.visibility != newView.visibility {
                scaleView.scaleVisibility = newView.visibility
            }

            if view?.alignment != newView.alignment {
                scaleView.legendAlignment = newView.alignment
            }
        }

    }

    // MARK: Stored Properties

    private let key: AnyHashable
    private let alignment: MKScaleView.Alignment
    private let visibility: MKFeatureVisibility

    // MARK: Initialization

    public init<Key: Hashable>(key: Key, alignment: MKScaleView.Alignment, visibility: MKFeatureVisibility) {
        self.key = key
        self.alignment = alignment
        self.visibility = visibility
    }

    // MARK: Methods

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

}

// MARK: - UIViewRepresentable

extension MapScale: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKScaleView {
        let view = MKScaleView(mapView: MapRegistry[key])
        updateUIView(view, context: context)
        return view
    }

    public func updateUIView(_ scaleView: MKScaleView, context: Context) {
        if let mapView = MapRegistry[key], mapView != scaleView.mapView {
            scaleView.mapView = mapView
        }
        context.coordinator.update(scaleView, with: self, context: context)
    }

}

#endif

//
//  MapUserTrackingButton.swift
//  Map
//
//  Created by Paul Kraft on 03.07.22.
//

#if canImport(UIKit) && !os(watchOS) && !os(tvOS)

import SwiftUI
import MapKit

public struct MapUserTrackingButton {

    // MARK: Stored Properties

    private let key: AnyHashable

    // MARK: Initialization

    public init<Key: Hashable>(key: Key) {
        self.key = key
    }

}

// MARK: - UIViewRepresentable

extension MapUserTrackingButton: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKUserTrackingButton {
        let view = MKUserTrackingButton(mapView: MapRegistry[key])
        updateUIView(view, context: context)
        return view
    }

    public func updateUIView(_ view: MKUserTrackingButton, context: Context) {
        if let mapView = MapRegistry[key], mapView != view.mapView {
            view.mapView = mapView
        }
    }

}

#endif

//
//  MapZoomControl.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if os(macOS) || targetEnvironment(macCatalyst)

import SwiftUI
import MapKit

@available(macCatalyst 14, macOS 11, *)
public struct MapZoomControl {

    // MARK: Stored Properties

    private let key: AnyHashable

    // MARK: Initialization

    public init<Key: Hashable>(key: Key) {
        self.key = key
    }

}

#endif

// MARK: - UIViewRepresentable

#if targetEnvironment(macCatalyst)

@available(macCatalyst 14, *)
extension MapZoomControl: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKZoomControl {
        let view = MKZoomControl(mapView: MapRegistry[key])
        updateUIView(view, context: context)
        return view
    }

    public func updateUIView(_ zoomControl: MKZoomControl, context: Context) {
        if let mapView = MapRegistry[key], mapView != zoomControl.mapView {
            zoomControl.mapView = mapView
        }
    }

}


#endif


// MARK: - NSViewRepresentable

#if os(macOS)

@available(macOS 11, *)
extension MapZoomControl: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKZoomControl {
        let view = MKZoomControl(mapView: MapRegistry[key])
        updateNSView(view, context: context)
        return view
    }

    public func updateNSView(_ zoomControl: MKZoomControl, context: Context) {
        if let mapView = MapRegistry[key], mapView != zoomControl.mapView {
            zoomControl.mapView = mapView
        }
    }

}

#endif
