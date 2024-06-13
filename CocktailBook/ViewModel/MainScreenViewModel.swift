//
//  MainScreenViewModel.swift
//  CocktailBook
//
//  Created by apple on 13/06/24.
//

import Foundation

class MainScreenViewModel: ObservableObject {
    
    enum FilterState: String, CaseIterable {
           case all = "All Cocktails"
           case alcoholic = "Alcoholic"
           case nonAlcoholic = "Non-Alcoholic"
       }
    
    @Published var cocktails: [Cocktail] = []
    @Published var filterState: FilterState = .all
    @Published var errorMessage = ""
    @Published var isLoading = true
    
    private let cocktailsAPI: CocktailsAPI
    let favoritesManager: FavoritesManaging
    
    init(cocktailsAPI: CocktailsAPI = FakeCocktailsAPI(), favoritesManager: FavoritesManaging = FavoritesManager()) {
        self.cocktailsAPI = CommandLine.arguments.contains("UITest_FailureAPI") ? FakeCocktailsAPI(withFailure: .count(2)) : cocktailsAPI
        self.favoritesManager = favoritesManager
        loadCocktails()
    }
    
    var filteredCocktails: [Cocktail] {
        let filtered: [Cocktail]
            switch filterState {
            case .all:
                filtered = cocktails
            case .alcoholic:
                filtered = cocktails.filter { $0.type == "alcoholic" }
            case .nonAlcoholic:
                filtered = cocktails.filter { $0.type != "alcoholic"  }
            }
        
        let favorites = filtered.filter { $0.isFavorite }.sorted { $0.name < $1.name }
                let nonFavorites = filtered.filter { !$0.isFavorite }.sorted { $0.name < $1.name }
                
                return favorites + nonFavorites
        }
    
    func loadCocktails() {
        isLoading = true
        cocktailsAPI.fetchCocktails { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cocktails):
                DispatchQueue.main.async {
                    self.cocktails = cocktails.map { cocktail in
                        var newCocktail = cocktail
                        newCocktail.isFavorite = self.favoritesManager.isFavorite(cocktail.id)
                        return newCocktail
                    }
                    self.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
