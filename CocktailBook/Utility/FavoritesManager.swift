//
//  FavoritesManager.swift
//  CocktailBook
//
//  Created by apple on 08/06/24.
//

import Foundation


protocol FavoritesManaging {
    func saveFavorites(_ favorites: [String])
    func loadFavorites() -> [String]
    func addFavorite(_ id: String)
    func removeFavorite(_ id: String)
    func isFavorite(_ id: String) -> Bool
}

class FavoritesManager: FavoritesManaging, ObservableObject {
    private let favoritesKey = "favoriteCocktails"
    
    func saveFavorites(_ favorites: [String]) {
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func loadFavorites() -> [String] {
        return UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
    }
    
    func addFavorite(_ id: String) {
        var favorites = loadFavorites()
        if !favorites.contains(id) {
            favorites.append(id)
            saveFavorites(favorites)
        }
    }
    
    func removeFavorite(_ id: String) {
        var favorites = loadFavorites()
        if let index = favorites.firstIndex(of: id) {
            favorites.remove(at: index)
            saveFavorites(favorites)
        }
    }
    
    func isFavorite(_ id: String) -> Bool {
        return loadFavorites().contains(id)
    }
}
