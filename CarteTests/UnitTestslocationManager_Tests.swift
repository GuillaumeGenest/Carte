//
//  UnitTestslocationManager_Tests.swift
//  CarteTests
//
//  Created by Guillaume Genest on 14/06/2023.
//

import XCTest
import MapKit
import CoreLocation
@testable import Carte

final class UnitTestslocationManager_Tests: XCTestCase {

    var viewModel : locationManager?

    override func setUpWithError() throws {
        viewModel = locationManager()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func test_locationManager_init() throws {
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        XCTAssertNotNil(vm)
    }
    
    func testStartUpdatingLocation() {
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        vm.startUpdatingLocation()
        XCTAssertTrue(vm.isUpdatingLocation)
    }

    func testStopUpdatingLocation() {
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        vm.startUpdatingLocation()
        XCTAssertTrue(vm.isUpdatingLocation)

        vm.stopUpdatingLocation()
        XCTAssertFalse(vm.isUpdatingLocation)
    }
    
    
}
