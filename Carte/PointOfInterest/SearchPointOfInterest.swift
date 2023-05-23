//
//  SearchPointOfInterest.swift
//  Carte
//
//  Created by Guillaume Genest on 22/05/2023.
//

import Foundation
import MapKit
import UIKit


class SearchPointOfInterest: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    var searchRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.861, longitude: 2.335833), latitudinalMeters: 8000, longitudinalMeters: 8000)
    private var localSearch: MKLocalSearch?
    @Published var places: [PointOfInterest] = []
    private var searchCompleter: MKLocalSearchCompleter
    //initilialiser en fonction du currentLocation

    
    
    override init() {
        searchCompleter = MKLocalSearchCompleter()
            super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .pointOfInterest
        searchCompleter.pointOfInterestFilter = MKPointOfInterestFilter(including: [.museum])
        searchCompleter.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), span: MKCoordinateSpan(latitudeDelta: 8000, longitudeDelta: 8000))
        searchCompleter.queryFragment = "palais"
        }

    
    func searchMuseums() {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = "palais"
            search(using: searchRequest)
        }
    
    
    
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    private func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        
        //A revoir pour le point d'interet
        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: MKPointOfInterestCategory.travelPointsOfInterest)
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    private func search(using searchRequest: MKLocalSearch.Request) {
        searchRequest.region = searchRegion
        searchRequest.resultTypes = .pointOfInterest
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [weak self] response, error in
            guard let self = self else { return }
                if let mapItems = response?.mapItems {
                            DispatchQueue.main.async {
                                self.places = mapItems.map { mapItem in
                                    return PointOfInterest(mapItem: mapItem)
                                }
                            }
                        }
                    }
            // This view controller sets the map view's region in `prepareForSegue` based on the search response's bounding region.
//            if let updatedRegion = response?.boundingRegion {
//                searchRegion = updatedRegion
//            }

    }
    
    private func displaySearchError(_ error: Error?) {
        guard let error = error as NSError? else { return }
        
        let alertTitle = NSLocalizedString("SEARCH_RESULTS_ERROR_TITLE", comment: "Error alert title")
        let alertController = UIAlertController(title: alertTitle, message: error.description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("BUTTON_OK", comment: "OK alert button"), style: .default) { _ in
            // Add any additional button-handling code here.
        }
        alertController.addAction(okAction)
        //present(alertController, animated: true, completion: nil)
    }
}

