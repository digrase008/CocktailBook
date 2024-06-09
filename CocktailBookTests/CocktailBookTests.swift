import XCTest
@testable import CocktailBook

class CocktailBookTests: XCTestCase {

    var favoritesManager: FavoritesManager!
    var cocktailsAPI: FakeCocktailsAPI!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        favoritesManager = FavoritesManager()
        cocktailsAPI = FakeCocktailsAPI(withFailure: .count(1))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        favoritesManager = nil
        cocktailsAPI = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLoadCocktailsWithRetries() throws {
            let expectation = XCTestExpectation(description: "Cocktails loaded after multiple failures")
            
            var attempt = 0
            func attemptLoadCocktails() {
                cocktailsAPI.fetchCocktails { result in
                    attempt += 1
                    switch result {
                    case .success(let data):
                        do {
                            let decodedCocktails = try JSONDecoder().decode([Cocktail].self, from: data)
                            XCTAssertEqual(decodedCocktails.count, 13, "Expected 13 cocktails to be loaded")
                            XCTAssertEqual(attempt, 2, "Expected 3 failures before success")
                            expectation.fulfill()
                        } catch {
                            XCTFail("Decoding error: \(error)")
                        }
                    case .failure(let error):
                        if attempt < 2 {
                            attemptLoadCocktails()
                        } else {
                            XCTFail("Expected success after 3 failures, but received an error: \(error)")
                        }
                    }
                }
            }
            
            attemptLoadCocktails()
            
            wait(for: [expectation], timeout: 10.0)
        }
        
        func testToggleFavorite() throws {
            let cocktail = Cocktail(
                        id: "7",
                        name: "Margarita",
                        type: "alcoholic",
                        shortDescription: "A sweet tequila-based party drink that's easy to make in batches.",
                        longDescription: "A margarita is a cocktail consisting of tequila, orange liqueur, and lime juice often served with salt on the rim of the glass. The drink is served shaken with ice, blended with ice, or without ice.",
                        preparationMinutes: 5,
                        imageName: "margarita",
                        ingredients: [
                                      "1 (6 ounce) can frozen limeade concentrate",
                                      "6 fluid ounces tequila",
                                      "2 fluid ounces triple sec"
                                     ],
                        isFavorite: false
                    )
                    
                    favoritesManager.addFavorite(cocktail.id)
                    XCTAssertTrue(favoritesManager.isFavorite(cocktail.id), "Cocktail should be a favorite")
                    
                    favoritesManager.removeFavorite(cocktail.id)
                    XCTAssertFalse(favoritesManager.isFavorite(cocktail.id), "Cocktail should not be a favorite")
        }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            _ = favoritesManager.loadFavorites()
        }
    }

}
