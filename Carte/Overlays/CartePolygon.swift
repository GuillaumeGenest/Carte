//
//  CartePolygon.swift
//  Carte
//
//  Created by Guillaume Genest on 12/05/2023.
//

import Foundation
import MapKit
import SwiftUI

public struct CartePolygon: MapOverlay {

    // MARK: Stored Properties

    public let overlay: MKOverlay
    public let level: MKOverlayLevel?

    private let fillColor: Color?
    private let nativeFillColor: NativeColor?
    private let lineWidth: CGFloat?
    private let strokeColor: Color?
    private let nativeStrokeColor: NativeColor?

    // MARK: Initialization

    public init(coordinates: [CLLocationCoordinate2D], interiorPolygons: [CartePolygon]? = nil, level: MKOverlayLevel? = nil, fillColor: NativeColor? = nil, lineWidth: CGFloat? = nil, strokeColor: NativeColor? = nil) {
        self.overlay = MKPolygon(coordinates: coordinates, count: coordinates.count, interiorPolygons: interiorPolygons?.compactMap { $0.overlay as? MKPolygon })
        self.level = level
        self.fillColor = nil
        self.nativeFillColor = fillColor
        self.lineWidth = lineWidth
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
    }

    public init(points: [MKMapPoint], interiorPolygons: [CartePolygon]? = nil, level: MKOverlayLevel? = nil, fillColor: NativeColor? = nil, lineWidth: CGFloat? = nil, strokeColor: NativeColor? = nil) {
        self.overlay = MKPolygon(points: points, count: points.count, interiorPolygons: interiorPolygons?.compactMap { $0.overlay as? MKPolygon })
        self.level = level
        self.fillColor = nil
        self.nativeFillColor = fillColor
        self.lineWidth = lineWidth
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
    }

    public init(polygon: MKPolygon, level: MKOverlayLevel? = nil, fillColor: NativeColor? = nil, lineWidth: CGFloat? = nil, strokeColor: NativeColor? = nil) {
        self.overlay = polygon
        self.level = level
        self.fillColor = nil
        self.nativeFillColor = fillColor
        self.lineWidth = lineWidth
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(coordinates: [CLLocationCoordinate2D], interiorPolygons: [CartePolygon]? = nil, level: MKOverlayLevel? = nil, fillColor: Color?, lineWidth: CGFloat? = nil, strokeColor: Color?) {
        self.overlay = MKPolygon(coordinates: coordinates, count: coordinates.count, interiorPolygons: interiorPolygons?.compactMap { $0.overlay as? MKPolygon })
        self.level = level
        self.fillColor = fillColor
        self.nativeFillColor = nil
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(points: [MKMapPoint], interiorPolygons: [CartePolygon]? = nil, level: MKOverlayLevel? = nil, fillColor: Color?, lineWidth: CGFloat? = nil, strokeColor: Color?) {
        self.overlay = MKPolygon(points: points, count: points.count, interiorPolygons: interiorPolygons?.compactMap { $0.overlay as? MKPolygon })
        self.level = level
        self.fillColor = fillColor
        self.nativeFillColor = nil
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(polygon: MKPolygon, level: MKOverlayLevel? = nil, fillColor: Color?, lineWidth: CGFloat? = nil, strokeColor: Color?) {
        self.overlay = polygon
        self.level = level
        self.fillColor = fillColor
        self.nativeFillColor = nil
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
    }

    // MARK: Methods

    public func renderer(for mapView: MKMapView) -> MKOverlayRenderer {
        let renderer = (overlay as? MKPolygon)
            .map { MKPolygonRenderer(polygon: $0) }
            ?? MKPolygonRenderer(overlay: overlay)

        if let fillColor = fillColor, #available(iOS 14, macOS 11, tvOS 14, *) {
            renderer.fillColor = .init(fillColor)
        } else if let fillColor = nativeFillColor {
            renderer.fillColor = fillColor
        }
        if let lineWidth = lineWidth {
            renderer.lineWidth = lineWidth
        }
        if let strokeColor = strokeColor, #available(iOS 14, macOS 11, tvOS 14, *) {
            renderer.strokeColor = .init(strokeColor)
        } else if let strokeColor = nativeStrokeColor {
            renderer.strokeColor = strokeColor
        }

        return renderer
    }

}

public struct CartePolyline: MapOverlay {

    // MARK: Stored Properties

    public let overlay: MKOverlay
    public let level: MKOverlayLevel?

    private let lineWidth: CGFloat?
    private let strokeColor: Color?
    private let nativeStrokeColor: NativeColor?
    
    // MARK: Initialization

    public init(coordinates: [CLLocationCoordinate2D], level: MKOverlayLevel? = nil, strokeColor: NativeColor? = nil, lineWidth: CGFloat? = nil) {
        self.overlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.level = level
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
        self.lineWidth = lineWidth
    }

    public init(points: [MKMapPoint], level: MKOverlayLevel? = nil, strokeColor: NativeColor? = nil, lineWidth: CGFloat? = nil) {
        self.overlay = MKPolyline(points: points, count: points.count)
        self.level = level
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
        self.lineWidth = lineWidth
    }

    public init(polyline: MKPolyline, level: MKOverlayLevel? = nil, strokeColor: NativeColor? = nil, lineWidth: CGFloat? = nil) {
        self.overlay = polyline
        self.level = level
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
        self.lineWidth = lineWidth
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(coordinates: [CLLocationCoordinate2D], level: MKOverlayLevel? = nil, strokeColor: Color?, lineWidth: CGFloat? = nil) {
        self.overlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.level = level
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
        self.lineWidth = lineWidth
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(points: [MKMapPoint], level: MKOverlayLevel? = nil, strokeColor: Color?, lineWidth: CGFloat? = nil) {
        self.overlay = MKPolyline(points: points, count: points.count)
        self.level = level
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
        self.lineWidth = lineWidth
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(polyline: MKPolyline, level: MKOverlayLevel? = nil, strokeColor: Color?, lineWidth: CGFloat? = nil) {
        self.overlay = polyline
        self.level = level
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
        self.lineWidth = lineWidth
    }

    // MARK: Methods

    public func renderer(for mapView: MKMapView) -> MKOverlayRenderer {
        let renderer = (overlay as? MKPolyline)
            .map { MKPolylineRenderer(polyline: $0) }
            ?? MKPolylineRenderer(overlay: overlay)

        if let lineWidth = lineWidth {
            renderer.lineWidth = lineWidth
        }
        if let strokeColor = strokeColor, #available(iOS 14, macOS 11, tvOS 14, *) {
            renderer.strokeColor = .init(strokeColor)
        } else if let strokeColor = nativeStrokeColor {
            renderer.strokeColor = strokeColor
        }

        return renderer
    }

}


import Foundation
import MapKit

public struct RendererCarteOverlay: MapOverlay {

    // MARK: Stored Properties

    public let overlay: MKOverlay
    public let level: MKOverlayLevel?
    private let _renderer: (MKMapView, MKOverlay) -> MKOverlayRenderer

    // MARK: Initialization

    public init(overlay: MKOverlay, level: MKOverlayLevel? = nil, renderer: @escaping (MKMapView, MKOverlay) -> MKOverlayRenderer) {
        self.overlay = overlay
        self.level = level
        self._renderer = renderer
    }

    // MARK: Methods

    public func renderer(for mapView: MKMapView) -> MKOverlayRenderer {
        _renderer(mapView, overlay)
    }

}
