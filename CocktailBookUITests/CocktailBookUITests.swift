import XCTest

class CocktailBookUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
    
    func testRetryButtonAppearsAfterFailures() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UITest_FailureAPI")
        app.launch()
        
        let noDataText = app.staticTexts["NoDataText"]
        XCTAssertTrue(noDataText.waitForExistence(timeout: 10), "No data available message should appear")
        
        XCTAssertTrue(app.buttons["RetryButton"].waitForExistence(timeout: 10), "Retry button should appear after multiple failures")
    }
    
    func testDataDisplayedAfterLoading() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.cells.element(boundBy: 0).waitForExistence(timeout: 10), "Data should be displayed after loading")
    }
    
    func testNavigationToDetailsScreen() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Assuming there's at least one cell displayed
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "First cell should exist")
        
        // Tap on the first cell
        firstCell.tap()
        
        // Check if details screen is displayed
        XCTAssertTrue(app.navigationBars.buttons.element(boundBy: 0).waitForExistence(timeout: 10), "Details screen should appear after tapping on cell")
    }
    
    
    func testErrorHandling() throws {
        let app = XCUIApplication()
            app.launchArguments.append("UITest_FailureAPI")
            app.launch()
            
        let errorAlert = app.alerts["Error"]
        XCTAssertTrue(errorAlert.waitForExistence(timeout: 10), "Error alert should appear")
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
