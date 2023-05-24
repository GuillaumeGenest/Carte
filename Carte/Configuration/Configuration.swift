//
//  Configuration.swift
//  Carte
//
//  Created by Guillaume Genest on 12/05/2023.
//

import Foundation
import Foundation
import MapKit
import SwiftUI

private enum MapBoundaryKey: EnvironmentKey {

    static var defaultValue: MKMapView.CameraBoundary? { nil }

}

extension EnvironmentValues {

    var mapBoundary: MKMapView.CameraBoundary? {
        get { self[MapBoundaryKey.self] }
        set { self[MapBoundaryKey.self] = newValue }
    }

}

extension View {

    public func mapBoundary(_ boundary: MKMapView.CameraBoundary?) -> some View {
        environment(\.mapBoundary, boundary)
    }

}


private enum MapZoomRangeKey: EnvironmentKey {

    static var defaultValue: MKMapView.CameraZoomRange? { nil }

}

extension EnvironmentValues {

    var mapZoomRange: MKMapView.CameraZoomRange? {
        get { self[MapZoomRangeKey.self] }
        set { self[MapZoomRangeKey.self] = newValue }
    }

}

extension View {

    public func mapZoomRange(_ range: MKMapView.CameraZoomRange?) -> some View {
        environment(\.mapZoomRange, range)
    }

}

public struct MapInformationVisibility: OptionSet {

    // MARK: Static Properties

    @available(watchOS, unavailable)
    public static let buildings = MapInformationVisibility(rawValue: 1 << 0)

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let compass = MapInformationVisibility(rawValue: 1 << 1)

    #if targetEnvironment(macCatalyst)
    @available(macCatalyst 14, *)
    public static let pitchControl = MapInformationVisibility(rawValue: 1 << 2)
    #else
    @available(iOS, unavailable)
    @available(macOS 11, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let pitchControl = MapInformationVisibility(rawValue: 1 << 2)
    #endif

    @available(watchOS, unavailable)
    public static let scale = MapInformationVisibility(rawValue: 1 << 3)

    @available(watchOS, unavailable)
    public static let traffic = MapInformationVisibility(rawValue: 1 << 4)

    @available(iOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS 6.1, *)
    public static let userHeading = MapInformationVisibility(rawValue: 1 << 5)

    @available(watchOS 6.1, *)
    public static let userLocation = MapInformationVisibility(rawValue: 1 << 6)

    #if targetEnvironment(macCatalyst)
    public static let zoomControls = MapInformationVisibility(rawValue: 1 << 7)
    #else
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let zoomControls = MapInformationVisibility(rawValue: 1 << 7)
    #endif

    public static let `default`: MapInformationVisibility = {
        #if os(watchOS)
        return []
        #else
        return [.buildings]
        #endif
    }()

    public static let all: MapInformationVisibility = {
        var value = MapInformationVisibility()

        #if !os(watchOS)
        value.insert(.buildings)
        #endif

        #if !os(tvOS) && !os(watchOS)
        value.insert(.compass)
        #endif

        #if os(macOS) || targetEnvironment(macCatalyst)
        if #available(macCatalyst 14, macOS 11, *) {
            value.insert(.pitchControl)
        }
        #endif

        #if !os(watchOS)
        value.insert(.scale)
        value.insert(.traffic)
        #endif

        #if os(watchOS)
        if #available(watchOS 6.1, *) {
            value.insert(.userHeading)
            value.insert(.userLocation)
        }
        #else
        value.insert(.userLocation)
        #endif

        #if os(macOS) || targetEnvironment(macCatalyst)
        value.insert(.zoomControls)
        #elseif targetEnvironment(macCatalyst)
        if #available(macCatalyst 14, *) {
            value.insert(.zoomControls)
        }
        #endif

        return value
    }()

    // MARK: Stored Properties

    public let rawValue: Int

    // MARK: Initialization

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}



public struct MapInteractionModes: OptionSet {

    // MARK: Static Properties

    public static let pan = MapInteractionModes(rawValue: 1 << 0)

    public static let zoom = MapInteractionModes(rawValue: 1 << 1)

    @available(tvOS, unavailable)
    public static let rotate = MapInteractionModes(rawValue: 1 << 2)

    @available(tvOS, unavailable)
    public static let pitch = MapInteractionModes(rawValue: 1 << 3)

    public static let all = MapInteractionModes(arrayLiteral: .pan, .zoom, .rotate, .pitch)

    // MARK: Stored Properties

    public let rawValue: Int

    // MARK: Initialization

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}


public enum UserTrackingMode {

    // MARK: Cases

    case none
    case follow

    @available(tvOS, unavailable)
    @available(macOS, unavailable)
    case followWithHeading

    // MARK: Computed Properties

    @available(macOS 11, *)
    var actualValue: MKUserTrackingMode {
        switch self {
        case .none:
            return .none
        case .follow:
            return .follow
        #if !os(macOS) && !os(tvOS)
        case .followWithHeading:
            return .followWithHeading
        #endif
            
        }
    }

}


public typealias MapAnnotationBuilder = SingleValueBuilder<CarteAnnotationProtocol>
public typealias OptionalMapAnnotationBuilder = SingleValueBuilder<CarteAnnotationProtocol?>

#if !os(watchOS)
public typealias MapOverlayBuilder = SingleValueBuilder<MapOverlay>
#endif

@resultBuilder
public enum SingleValueBuilder<Component> {

    public static func buildBlock(_ component: Component) -> Component {
        component
    }

    public static func buildEither(first component: Component) -> Component {
        component
    }

    public static func buildEither(second component: Component) -> Component {
        component
    }

    public static func buildLimitedAvailability(_ component: Component) -> Component {
        component
    }

}
