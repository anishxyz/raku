//
//  RakuAPIManagerTests.swift
//  rakuTests
//
//  Created by Anish Agrawal on 12/9/24.
//

import Foundation
import XCTest
@testable import raku

final class RakuAPIManagerTests: XCTestCase {

    func testFetchContributions() {
        // Create an expectation for the async operation
        let expectation = self.expectation(description: "Fetch contributions")
        
        // Define input dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: "2022-06-30")!
        let endDate = dateFormatter.date(from: "2024-12-08")!
        
        // Call the API
        RakuAPIManager.shared.fetchContributions(for: "anishxyz", startDate: startDate, endDate: endDate) { result in
            switch result {
            case .success(let contributionResponse):
                // Verify the results
                XCTAssertEqual(contributionResponse.user, "anishxyz")
                XCTAssertFalse(contributionResponse.contributions.isEmpty, "Contributions should not be empty.")
                XCTAssertEqual(contributionResponse.contributions.first?.count, 0) // Adjust as needed
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
            }
        }
        
        // Wait for expectations
        waitForExpectations(timeout: 10, handler: nil)
    }
}
