
import MapKit
import SwiftUI
import UIKit
import Foundation


class MKCarteAnnotationView<Content: View>: MKAnnotationView {

    // MARK: Stored Properties

    private var controller: NativeHostingController<Content>?

    // MARK: Methods

    func setup(for mapAnnotation: CarteAnnotation<Content>) {
        annotation = mapAnnotation.annotation
        clusteringIdentifier = mapAnnotation.clusteringIdentifier

        let controller = NativeHostingController(rootView: mapAnnotation.content)
        addSubview(controller.view)
        bounds.size = controller.preferredContentSize
        self.controller = controller
    }

    // MARK: Overrides

    #if canImport(UIKit)

    override func layoutSubviews() {
        super.layoutSubviews()

        if let controller = controller {
            bounds.size = controller.preferredContentSize
        }
    }

    #endif

    override func prepareForReuse() {
        super.prepareForReuse()

        #if canImport(UIKit)
        controller?.willMove(toParent: nil)
        #endif
        controller?.view.removeFromSuperview()
        controller?.removeFromParent()
        controller = nil
    }

}

public protocol MapAnnotation {

    // MARK: Static Functions

    static func registerView(on mapView: MKMapView)

    // MARK: Properties

    var annotation: MKAnnotation { get }

    // MARK: Methods

    func view(for mapView: MKMapView) -> MKAnnotationView?

}

extension MapAnnotation {

    static var reuseIdentifier: String {
        "__Carte__" + String(describing: self) + "__Carte__"
    }

}


public struct CarteAnnotation<Content: View>: MapAnnotation {

    // MARK: Nested Types

    private class Annotation: NSObject, MKAnnotation {

        // MARK: Stored Properties

        let coordinate: CLLocationCoordinate2D
        let title: String?
        let subtitle: String?

        // MARK: Initialization

        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }

    }

    // MARK: Static Functions

    public static func registerView(on mapView: MKMapView) {
        mapView.register(MKCarteAnnotationView<Content>.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: Stored Properties

    public let annotation: MKAnnotation
    let clusteringIdentifier: String?
    let content: Content

    // MARK: Initialization

    public init(
        coordinate: CLLocationCoordinate2D,
        title: String? = nil,
        subtitle: String? = nil,
        clusteringIdentifier: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.annotation = Annotation(coordinate: coordinate, title: title, subtitle: subtitle)
        self.clusteringIdentifier = clusteringIdentifier
        self.content = content()
    }

    public init(
        annotation: MKAnnotation,
        clusteringIdentifier: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.annotation = annotation
        self.clusteringIdentifier = clusteringIdentifier
        self.content = content()
    }

    // MARK: Methods

    public func view(for mapView: MKMapView) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: Self.reuseIdentifier,
            for: annotation
        ) as? MKCarteAnnotationView<Content>

        view?.setup(for: self)
        return view
    }

}

