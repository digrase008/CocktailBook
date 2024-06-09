//
//  MainScreen.swift
//  CocktailBook
//
//  Created by apple on 07/06/24.
//

import SwiftUI

struct MainScreen: View {
    @State private var cocktails: [Cocktail] = []
    @State private var filterState: FilterState = .all
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var isLoading = true
    private let cocktailsAPI: CocktailsAPI
    private let favoritesManager = FavoritesManager()
    
    init(cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()) {
            self.cocktailsAPI = cocktailsAPI
        }
    
    enum FilterState: String, CaseIterable {
        case all = "All Cocktails"
        case alcoholic = "Alcoholic"
        case nonAlcoholic = "Non-Alcoholic"
    }
    
    var filteredCocktails: [Cocktail] {
        let filtered: [Cocktail]
        switch filterState {
        case .all:
            filtered = cocktails
        case .alcoholic:
            filtered = cocktails.filter { $0.type == "alcoholic" }
        case .nonAlcoholic:
            filtered = cocktails.filter { $0.type != "alcoholic" }
        }
        
        let favorites = filtered.filter { $0.isFavorite }.sorted { $0.name < $1.name }
        let nonFavorites = filtered.filter { !$0.isFavorite }.sorted { $0.name < $1.name }
        
        return favorites + nonFavorites
    }
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Loading...")
                    .padding()
                    .accessibility(identifier: "LoadingIndicator")
            } else if cocktails.isEmpty {
                VStack {
                    Text("No data available.")
                        .padding()
                        .accessibility(identifier: "NoDataText")
                    Button(action: {
                        loadCocktails()
                    }) {
                        Text("Retry")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .accessibility(identifier: "RetryButton")
                    }
                }
            } else {
                List(filteredCocktails) { cocktail in
                    NavigationLink(destination: DetailsScreen(cocktail: cocktail, isFavorite: $cocktails[cocktails.firstIndex(where: { $0.id == cocktail.id })!].isFavorite, favoritesManager: favoritesManager, backText: filterState.rawValue)) {
                        HStack {
                            Image(cocktail.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            
                            VStack(alignment: .leading) {
                                Text(cocktail.name)
                                    .font(.headline)
                                    .foregroundColor(cocktail.isFavorite ? .red : .primary)
                                Text(cocktail.shortDescription)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if cocktail.isFavorite {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .accessibility(identifier: "FilterPicker")
                .navigationTitle(filterState.rawValue)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker("Filter", selection: $filterState) {
                            ForEach(FilterState.allCases, id: \.self) { state in
                                Text(state.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear(perform: {
            loadCocktails()
        })
    }
    
    private func loadCocktails() {
        isLoading = true
        let favorites = favoritesManager.loadFavorites()
        cocktailsAPI.fetchCocktails { result in
            
            switch result {
            case .success(let data):
                do {
                    var decodedCocktails = try JSONDecoder().decode([Cocktail].self, from: data)
                    // Merge favorites
                    for i in 0..<decodedCocktails.count {
                        if favorites.contains(decodedCocktails[i].id) {
                            decodedCocktails[i].isFavorite = true
                        }
                    }
                    DispatchQueue.main.async {
                        self.showAlert = false
                        self.errorMessage = ""
                        isLoading = false
                        self.cocktails = decodedCocktails
                    }
                    
                } catch {
                    self.errorMessage = "Failed to decode cocktails: \(error.localizedDescription)"
                    self.showAlert = true
                    isLoading = false
                }
            case .failure(let error):
                self.errorMessage = "Failed to fetch cocktails: \(error.localizedDescription)"
                self.showAlert = true
                isLoading = false
            }
            
        }
    }
}

#Preview {
    MainScreen()
}
