//
//  CurrencyConversionTests.swift
//  CurrencyConversionTests
//
//  Created by Srujan k on 01/12/20.
//

import XCTest
@testable import CurrencyConversion

class CurrencyConversionTests: XCTestCase {

    private let viewModel = CCViewModel()
    
    override func setUpWithError() throws {
        SharedMemory.shared.selectedCountry = Country(code: "INR", value: "India")
        SharedMemory.shared.enteredAmount = 12
    }
    func testgetListOfCountries()  {
        let expectation = self.expectation(description: "API_Request")
        viewModel.getListOfCountries { (countries) in
            if countries == nil{
                XCTAssertFalse(true, "Results Nil")
                expectation.fulfill()
            }
            if countries?.count != 0{
                SharedMemory.shared.countrylist?.append(contentsOf: countries ?? [Country]())
                XCTAssertTrue(true, "Received Results")
                expectation.fulfill()
            }else{
                XCTAssertFalse(true, "Results Emplty")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 30.0)
    }
    func testListOfCurrencies() {
        let exp = expectation(forNotification: .init(rawValue: Constants.DidReceiveLiveCurrency), object: nil) { (notification) -> Bool in
            if let userInfo = notification.userInfo, let currencyList = userInfo[Constants.currency] as? [Currency]{
                if currencyList.count == 0{
                    XCTAssertFalse(true, "Results Emplty")
                    return false
                }else{
                    XCTAssertTrue(true, "Received Results")
                    return true
                }
            }else{
                XCTAssertFalse(true, "Results Emplty")
                return false
            }
        }
        viewModel.listenForCurrencyList()
        wait(for: [exp], timeout: 60.0)
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
