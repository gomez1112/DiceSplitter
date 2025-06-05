//
//  DiceSplitterUITests.swift
//  DiceSplitterUITests
//
//  Created by Gerard Gomez on 1/26/25.
//

import XCTest

final class DiceSplitterUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    /// Walk through the onboarding flow and verify the game screen appears
    @MainActor
    func testOnboardingFlow() throws {
        let app = XCUIApplication()
        app.launch()

        // First screen of onboarding
        XCTAssertTrue(app.staticTexts["Welcome to DiceSplitter"].waitForExistence(timeout: 2))

        // Step through to the last page
        for _ in 0..<4 { app.buttons["Next"].tap() }

        // Ensure the final button exists
        XCTAssertTrue(app.buttons["Get Started"].waitForExistence(timeout: 2))
        app.buttons["Get Started"].tap()

        // After completing onboarding, the main game view should be visible
        XCTAssertTrue(app.navigationBars["Dice Splitter"].waitForExistence(timeout: 2))
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
