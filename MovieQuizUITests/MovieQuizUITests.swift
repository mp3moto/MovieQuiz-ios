//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by  admin on 03.09.2022.
//
import XCTest

class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
        app = nil
    }

    func testYesButton() {
        let firstPoster = app.images["Poster"]
        app.buttons["Yes"].tap()
        let secondPoster = app.images["Poster"]
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testNoButton() {
        let firstPoster = app.images["Poster"]
        app.buttons["No"].tap()
        let secondPoster = app.images["Poster"]
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testAlertShowing() {
        var limitCounter = 0
        while app.staticTexts["Index"].label != "10/10" && limitCounter < 50 {
            app.buttons["Yes"].tap()
            limitCounter += 1
        }
        app.buttons["Yes"].tap()
        sleep(1)
        let alert = app.alerts.firstMatch
        let alertExists = alert.exists
        let titleMatch = alert.label == "Этот раунд окончен!"
        let buttonMatch = alert.buttons.firstMatch.label == "Сыграть еще раз!"
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз!")
        XCTAssertTrue(alertExists && titleMatch && buttonMatch)
    }

    func testQuizRestarted() {
        var limitCounter = 0
        while app.staticTexts["Index"].label != "10/10" && limitCounter < 50 {
            app.buttons["Yes"].tap()
            limitCounter += 1
        }
        app.buttons["Yes"].tap()
        sleep(1)
        let alert = app.alerts.firstMatch
        alert.buttons.firstMatch.tap()
        sleep(1)
        let indexMatch = app.staticTexts["Index"].label == "1/10"
        XCTAssertTrue(indexMatch)
    }
}
