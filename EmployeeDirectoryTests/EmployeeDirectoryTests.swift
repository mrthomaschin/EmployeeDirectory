//
//  EmployeeDirectoryTests.swift
//  EmployeeDirectoryTests
//
//  Created by Thomas Chin on 4/21/22.
//

import XCTest
@testable import EmployeeDirectory

class EmployeeDirectoryTests: XCTestCase {
    
    private var viewController: ViewController!
    private var viewModel: DirectoryViewModel!

    override func setUpWithError() throws {
        viewController = ViewController()
        viewModel = DirectoryViewModel.init()
    }
    
    func testFetchEmployeeList() {
        
        // GIVEN
        let populatedListUrl = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
        let expectedListSize = 11
        let expectation = self.expectation(description: "Fetch employee list")
        
        var result: [Employee]?
        var error: Error?
        
        // WHEN
        viewModel.fetchEmployeeData(url: populatedListUrl) { (response, errorResponse)  in
            result = response
            error = errorResponse
            expectation.fulfill()
        }
        
        // THEN
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(error == nil)
        XCTAssert(result!.isEmpty == false)
        XCTAssert(result!.count == expectedListSize)
    }
    
    func testFetchEmployeeListEmpty() {
        
        // GIVEN
        let emptyListUrl = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
        let expectation = self.expectation(description: "Fetch employee list")
        
        var result: [Employee]?
        var error: Error?
        
        // WHEN
        viewModel.fetchEmployeeData(url: emptyListUrl) { (response, errorResponse)  in
            result = response
            error = errorResponse
            expectation.fulfill()
        }
        
        // THEN
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(error == nil)
        XCTAssert(result!.isEmpty == true)
    }
    
    func testFetchEmployeeListMalformed() {
        
        // GIVEN
        let malformedListUrl = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
        let expectation = self.expectation(description: "Fetch employee list")
        
        var result: [Employee]?
        var error: Error?
        
        // WHEN
        viewModel.fetchEmployeeData(url: malformedListUrl) { (response, errorResponse)  in
            result = response
            error = errorResponse
            expectation.fulfill()
        }
        
        // THEN
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(result == nil)
        XCTAssert(error != nil)
        XCTAssert(error is DecodingError)
    }
    
    func testFetchEmployeeListInvalidUrl() {
        
        // GIVEN
        let invalidListUrl = "https://hello.there"
        let expectation = self.expectation(description: "Fetch employee list")
        
        var result: [Employee]?
        var error: Error?
        
        // WHEN
        viewModel.fetchEmployeeData(url: invalidListUrl) { (response, errorResponse)  in
            result = response
            error = errorResponse
            expectation.fulfill()
        }
        
        // THEN
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(result == nil)
        XCTAssert(error != nil)
    }
}
