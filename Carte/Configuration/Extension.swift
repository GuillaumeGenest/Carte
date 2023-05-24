//
//  Extension.swift
//  Carte
//
//  Created by Guillaume Genest on 12/05/2023.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

import Foundation

public struct IdentifiableObject<Object: AnyObject>: Identifiable {

    let object: Object

    public var id: ObjectIdentifier {
        ObjectIdentifier(object)
    }

}



import MapKit

extension CLLocationCoordinate2D {

    func equals(to other: CLLocationCoordinate2D) -> Bool {
        latitude == other.latitude
        && longitude == other.longitude
    }

}

extension MKCoordinateRegion {

    func equals(to other: MKCoordinateRegion) -> Bool {
        center.equals(to: other.center)
        && span.equals(to: other.span)
    }

}

extension MKCoordinateSpan {

    func equals(to other: MKCoordinateSpan) -> Bool {
        latitudeDelta == other.latitudeDelta
        && longitudeDelta == other.longitudeDelta
    }

}

extension MKMapPoint {

    func equals(to other: MKMapPoint) -> Bool {
        x == other.x
        && y == other.y
    }

}
extension MKMapRect {

    func equals(to other: MKMapRect) -> Bool {
        origin.equals(to: other.origin)
        && size.equals(to: other.size)
    }

}

extension MKMapSize {

    func equals(to other: MKMapSize) -> Bool {
        width == other.width
        && height == other.height
    }

}


#if !os(watchOS)

import MapKit
import SwiftUI

extension View {

    public func mapKey<Key: Hashable>(_ key: Key) -> some View {
        environment(\.mapKey, key)
    }

}

private enum MapEnvironmentKey: EnvironmentKey {

    static var defaultValue: AnyHashable? { nil }

}

extension EnvironmentValues {

    var mapKey: AnyHashable? {
        get { self[MapEnvironmentKey.self] }
        set { self[MapEnvironmentKey.self] = newValue }
    }

}

enum MapRegistry {

    private static var content = [AnyHashable: Value]()

    private struct Value {
        weak var object: MKMapView?
    }

    static func clean() {
        for (key, value) in content where value.object == nil {
            content.removeValue(forKey: key)
        }
    }

    static subscript(_ key: AnyHashable) -> MKMapView? {
        get { content[key]?.object }
        set { content[key] = newValue.map { Value(object: $0) } }
    }

}

#endif

#if canImport(UIKit) && !os(watchOS)

import UIKit
import SwiftUI

typealias NativeHostingController = UIHostingController

#elseif canImport(AppKit)

import AppKit
import SwiftUI

typealias NativeHostingController = NSHostingController

#endif

public typealias NativeColor = UIColor



extension UIHostingController {
        convenience public init(rootView: Content, ignoreSafeArea: Bool) {
            self.init(rootView: rootView)
            
            if ignoreSafeArea {
                disableSafeArea()
            }
        }
        
        func disableSafeArea() {
            guard let viewClass = object_getClass(view) else { return }
            
            let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoreSafeArea")
            if let viewSubclass = NSClassFromString(viewSubclassName) {
                object_setClass(view, viewSubclass)
            }
            else {
                guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
                guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }
                
                if let method = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets)) {
                    let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { _ in
                        return .zero
                    }
                    class_addMethod(viewSubclass, #selector(getter: UIView.safeAreaInsets),
                                    imp_implementationWithBlock(safeAreaInsets),
                                    method_getTypeEncoding(method))
                }
                
                objc_registerClassPair(viewSubclass)
                object_setClass(view, viewSubclass)
            }
        }
    }

