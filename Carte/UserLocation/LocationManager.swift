//
//  LocationManager.swift
//  Carte
//
//  Created by Guillaume Genest on 14/06/2023.
//

import Foundation
import CoreLocation
import MapKit
import UIKit


final class locationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var location : CLLocation?
    var isUpdatingLocation = false
    private let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        self.isUpdatingLocation = false
    }
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        self.isUpdatingLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }

    
}
