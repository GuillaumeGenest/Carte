//
//  UnitTestsSearchModel_Tests.swift
//  CarteTests
//
//  Created by Guillaume Genest on 06/06/2023.
//

import XCTest
import MapKit
@testable import Carte

final class UnitTestsSearchModel_Tests: XCTestCase {
    
    var viewModel : SearchPointOfInterests?

    override func setUpWithError() throws {
        viewModel = SearchPointOfInterests()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    
    
    func test_SearchPointOfInterests_PointOfInterest_shouldBeEmpty(){
        let vm = SearchPointOfInterests()
        
        XCTAssertTrue(vm.pointsOfInterest.isEmpty)
        XCTAssertEqual(vm.pointsOfInterest.count, 0)
    }
    
    
    
    func test_SearchPointOfInterests_UpdateRegion_ShouldUpdateRegionWithDifferentWays() {
            // Configurez  une région de test
            let vm = SearchPointOfInterests()
            let center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            
            // Mettez à jour la région de recherche
            vm.updateRegion(center: center, span: span)
            
            // Vérifiez que la région est correctement mise à jour
            XCTAssertEqual(vm.searchRegion.center.latitude, center.latitude)
            XCTAssertEqual(vm.searchRegion.center.longitude, center.longitude)
            XCTAssertEqual(vm.searchRegion.span.latitudeDelta, span.latitudeDelta)
            XCTAssertEqual(vm.searchRegion.span.longitudeDelta, span.longitudeDelta)
        }

    func test_SearchPointOfInterests_searchPointsOfInterest_shouldfetchallpointOfInterest() {
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        let expectation = XCTestExpectation(description: "Search Points of Interest")
                
        //Given
        
                // Configurez la région de recherche
        let center = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        let region = MKCoordinateRegion(center: center, span: span)
        vm.searchRegion = region
                
                // Effectuez la recherche
        vm.searchPointsOfInterest()
                
                // Vérifiez que les résultats sont mis à jour
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(vm.pointsOfInterest.isEmpty)
                expectation.fulfill()
        }
        
                // Attendre l'exécution de l'expectation
        wait(for: [expectation], timeout: 3.0)
    }

}
