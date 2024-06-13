//
//  File.swift
//  CocktailBook
//
//  Created by apple on 13/06/24.
//

import XCTest
@testable import CocktailBook

class FavoritesManagerTests: XCTestCase {
    
    var favoritesManager: FavoritesManager!
    
    override func setUp() {
        super.setUp()
        favoritesManager = FavoritesManager()
    }
    
    override func tearDown() {
        favoritesManager = nil
        super.tearDown()
    }
    
    func testAddFavorite() {
        favoritesManager.addFavorite("1")
        XCTAssertTrue(favoritesManager.isFavorite("1"), "Favorite should be added")
    }
    
    func testRemoveFavorite() {
        favoritesManager.addFavorite("2")
        favoritesManager.removeFavorite("2")
        XCTAssertFalse(favoritesManager.isFavorite("2"), "Favorite should be removed")
    }
    
    func testIsFavorite() {
        XCTAssertFalse(favoritesManager.isFavorite("3"), "No favorite should exist")
        favoritesManager.addFavorite("3")
        XCTAssertTrue(favoritesManager.isFavorite("3"), "Favorite should exist")
    }
    
    func testLoadFavorites() {
        let favorites = ["1", "2", "3"]
        favoritesManager.saveFavorites(favorites)
        XCTAssertEqual(favoritesManager.loadFavorites(), favorites, "Loaded favorites should match saved favorites")
    }
    
    func testSaveFavorites() {
        let favorites = ["4", "5", "6"]
        favoritesManager.saveFavorites(favorites)
        XCTAssertEqual(UserDefaults.standard.stringArray(forKey: "favoriteCocktails"), favorites, "Saved favorites should match UserDefaults")
    }
}

