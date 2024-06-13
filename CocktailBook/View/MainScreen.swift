//
//  MainScreen.swift
//  CocktailBook
//
//  Created by apple on 07/06/24.
//

import SwiftUI

struct MainScreen: View {
    @StateObject private var viewModel = MainScreenViewModel()
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
                    .accessibility(identifier: "LoadingIndicator")
            } else if viewModel.cocktails.isEmpty {
                VStack {
                    Text("No data available.")
                        .padding()
                        .accessibility(identifier: "NoDataText")
                    Button(action: {
                        viewModel.loadCocktails()
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
                List(viewModel.filteredCocktails) { cocktail in
                    NavigationLink(destination: DetailsScreen(cocktail: cocktail,
                                                               isFavorite: $viewModel.cocktails[viewModel.cocktails.firstIndex(where: { $0.id == cocktail.id })!].isFavorite,
                                                               favoritesManager: viewModel.favoritesManager,
                                                               backText: viewModel.filterState.rawValue)) {
                        CocktailRow(cocktail: cocktail)
                    }
                }
                .accessibility(identifier: "FilterPicker")
                .navigationTitle(viewModel.filterState.rawValue) // Removed $ sign here
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker("Filter", selection: $viewModel.filterState) {
                            ForEach(MainScreenViewModel.FilterState.allCases, id: \.self) { state in
                                Text(state.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
        }
        .alert(isPresented: .constant(!viewModel.errorMessage.isEmpty)) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK")) {
                    viewModel.errorMessage = ""
                }
            )
        }
        .onAppear {
            viewModel.loadCocktails()
        }
    }
}

#Preview {
    MainScreen()
        .environmentObject(MainScreenViewModel())
}
