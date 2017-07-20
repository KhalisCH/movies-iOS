//
//  MoviesUITests.swift
//  MoviesUITests
//
//  Created by Khalis on 20/07/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import XCTest

class MoviesUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomeTabBarRedirection() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIApplication().tabBars.buttons["Home"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["Home"].exists)
    }
    
    func testMoviesTabBarRedirection() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIApplication().tabBars.buttons["Movies"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["Movies"].exists)
    }

    func testTVShowsTabBarRedirection() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIApplication().tabBars.buttons["TV Shows"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["TV Shows"].exists)
    }
    
    func testProfileTabBarRedirection() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIApplication().tabBars.buttons["Profile"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["Account"].exists)
    }

}
