//
//  SearchPointOfInterest.swift
//  Carte
//
//  Created by Guillaume Genest on 22/05/2023.
//

import Foundation
import MapKit
import UIKit


class SearchPointOfInterests: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var pointsOfInterest: [PointOfInterest] = []
    @Published var selectedType: PointOfInterestType = .Monument
    @Published var ShowPointOfInterest: Bool = false
    @Published var ShowInformationMapItem: Bool = false
    @Published var ShowPointOfInterestOnMap: Bool = false
    
    
    @Published var ShowDetailPlaceAnnotation : PointOfInterest?
    
    
    @Published var searchRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.188529, longitude: 5.724524), latitudinalMeters: 20000, longitudinalMeters: 20000)

 override init() {
        super.init()
    }

func searchPointsOfInterest() {
        let group = DispatchGroup()
        var combinedResults: [PointOfInterest] = []

        let searchTypes: [String] = selectedType.queries

        for type in searchTypes {
            group.enter()
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = type
            searchRequest.region = searchRegion
            searchRequest.resultTypes = .pointOfInterest

            let localSearch = MKLocalSearch(request: searchRequest)
            localSearch.start { [weak self] response, error in
                guard let self = self else { return }

                if let mapItems = response?.mapItems {
                    let results = mapItems.map { mapItem in
                        return PointOfInterest(mapItem: mapItem)
                    }
                    combinedResults.append(contentsOf: results)
                }

                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.pointsOfInterest = combinedResults
        }
    }
    func updateRegion(center: CLLocationCoordinate2D, span: MKCoordinateSpan) {
            searchRegion = MKCoordinateRegion(center: center, span: span)
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Ne pas implémenter cette méthode si vous ne souhaitez pas utiliser MKLocalSearchCompleter
    }
}


extension SearchPointOfInterests {

        private func displaySearchError(_ error: Error?) {
            guard let error = error as NSError? else { return }
    
            let alertTitle = NSLocalizedString("SEARCH_RESULTS_ERROR_TITLE", comment: "Error alert title")
            let alertController = UIAlertController(title: alertTitle, message: error.description, preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("BUTTON_OK", comment: "OK alert button"), style: .default) { _ in
            }
            alertController.addAction(okAction)
        }
}
