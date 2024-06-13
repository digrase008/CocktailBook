//
//  DetailsScreen.swift
//  CocktailBook
//
//  Created by apple on 07/06/24.
//

import SwiftUI

struct DetailsScreen: View {
    let cocktail: Cocktail
    @Binding var isFavorite: Bool
    let favoritesManager: FavoritesManaging
    let backText: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "clock")
                                Text("\(cocktail.preparationMinutes) Minutes")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding([.leading, .trailing])
                            
                            HStack {
                                Spacer()
                                Image(cocktail.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 200)
                                Spacer()
                            }
                            
                            Text(cocktail.longDescription)
                                .padding()
                            
                            Text("Ingredients")
                                .font(.headline)
                                .padding([.leading, .trailing, .top])
                            
                            ForEach(cocktail.ingredients, id: \.self) { ingredient in
                                HStack {
                                    Image(systemName: "arrowtriangle.right.fill")
                                    Text(ingredient)
                                }
                                .padding([.leading, .trailing, .bottom], 5)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .frame(width: geometry.size.width)
                    }
                }
        .navigationTitle(cocktail.name)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Image(systemName: "chevron.left").foregroundColor(.red)
                    Text(backText)
                        .foregroundColor(.red)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isFavorite.toggle()
                    updateFavorites()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart").foregroundColor(.red)
                }
            }
        }
    }
    
    private func updateFavorites() {
        if isFavorite {
            favoritesManager.addFavorite(cocktail.id)
        } else {
            favoritesManager.removeFavorite(cocktail.id)
        }
    }
}


#Preview {
    DetailsScreen(
        cocktail: Cocktail(
            id: "1",
            name: "Mojito",
            type: "alcoholic",
            shortDescription: "A refreshing Cuban classic made with white rum and muddled fresh mint.",
            longDescription: "This is an authentic recipe for mojito. I sized the recipe for one serving, but you can adjust it accordingly and make a pitcher full. It's a very refreshing drink for hot summer days. Be careful when drinking it, however. If you make a pitcher you might be tempted to drink the whole thing yourself, and you just might find yourself talking Spanish in no time! Tonic water can be substituted instead of the soda water but the taste is different and somewhat bitter.",
            preparationMinutes: 10,
            imageName: "mojito",
            ingredients: [
                "10 fresh mint leaves",
                "½ lime, cut into 4 wedges",
                "2 tablespoons white sugar, or to taste",
                "1 cup ice cubes",
                "1 ½ fluid ounces white rum",
                "½ cup club soda"
            ],
            isFavorite: true
        ),
        isFavorite: .constant(true),
        favoritesManager: FavoritesManager(), // Provide a mock instance for preview
        backText: "All Cocktails"
    )
}
