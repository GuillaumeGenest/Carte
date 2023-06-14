//
//  SearchPointOfInterest.swift
//  Carte
//
//  Created by Guillaume Genest on 22/05/2023.
//

import Foundation
import MapKit
import UIKit

//
//class SearchPointOfInterest: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
//
//    var searchRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.861, longitude: 2.335833), latitudinalMeters: 8000, longitudinalMeters: 8000)
//
//
//
//    private var localSearch: MKLocalSearch?
//    @Published var places: [PointOfInterest] = []
//
//    private var searchCompleter: MKLocalSearchCompleter
//    //initilialiser en fonction du currentLocation
//
//
//
//    override init() {
//        searchCompleter = MKLocalSearchCompleter()
//            super.init()
//        searchCompleter.delegate = self
//        searchCompleter.resultTypes = .pointOfInterest
//        searchCompleter.pointOfInterestFilter = MKPointOfInterestFilter(including: [.restaurant])
//        searchCompleter.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), span: MKCoordinateSpan(latitudeDelta: 8000, longitudeDelta: 8000))
//        searchCompleter.queryFragment = "Restaurant"
//        }
//
//
//    func searchMuseums() {
//            let searchRequest = MKLocalSearch.Request()
//            searchRequest.naturalLanguageQuery = "Restaurant"
//            search(using: searchRequest)
//        }
//
//
//
//    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
//        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
//        search(using: searchRequest)
//    }
//
//    private func search(for queryString: String?) {
//        let searchRequest = MKLocalSearch.Request()
//
//        //A revoir pour le point d'interet
//        searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: MKPointOfInterestCategory.travelPointsOfInterest)
//        searchRequest.naturalLanguageQuery = queryString
//        search(using: searchRequest)
//    }
//
//    private func search(using searchRequest: MKLocalSearch.Request) {
//        searchRequest.region = searchRegion
//        searchRequest.region = searchRegion
//        searchRequest.resultTypes = .pointOfInterest
////searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [.museum, .castle, .palace])
//
//        localSearch = MKLocalSearch(request: searchRequest)
//        localSearch?.start { [weak self] response, error in
//            guard let self = self else { return }
//                if let mapItems = response?.mapItems {
//                            DispatchQueue.main.async {
//                                self.places = mapItems.map { mapItem in
//                                    return PointOfInterest(mapItem: mapItem)
//                                }
//                            }
//                        }
//                    }
//            // This view controller sets the map view's region in `prepareForSegue` based on the search response's bounding region.
////            if let updatedRegion = response?.boundingRegion {
////                searchRegion = updatedRegion
////            }
//
//    }
//
//    private func displaySearchError(_ error: Error?) {
//        guard let error = error as NSError? else { return }
//
//        let alertTitle = NSLocalizedString("SEARCH_RESULTS_ERROR_TITLE", comment: "Error alert title")
//        let alertController = UIAlertController(title: alertTitle, message: error.description, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: NSLocalizedString("BUTTON_OK", comment: "OK alert button"), style: .default) { _ in
//            // Add any additional button-handling code here.
//        }
//        alertController.addAction(okAction)
//        //present(alertController, animated: true, completion: nil)
//    }
//}


class SearchPointOfInterests: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var pointsOfInterest: [PointOfInterest] = []
    @Published var selectedType: PointOfInterestType = .Histoire
    @Published var ShowPointOfInterest: Bool = false
    @Published var ShowInformationMapItem: Bool = false
    @Published var ShowPointOfInterestOnMap: Bool = false 
    @Published var searchRegion: MKCoordinateRegion {
            didSet {
                searchPointsOfInterest()
            }
        }

 override init() {
        searchRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
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
        
    func searchPointsOfInterests() {
        searchPointsOfInterest()
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
