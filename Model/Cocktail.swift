//
//  Cocktail.swift
//  CocktailBook
//
//  Created by apple on 07/06/24.
//

import Foundation


struct Cocktail: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let shortDescription: String
    let longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
    var isFavorite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
            case id, name, type, shortDescription, longDescription, preparationMinutes, imageName, ingredients
        }

        init(id: String, name: String, type: String, shortDescription: String, longDescription: String, preparationMinutes: Int, imageName: String, ingredients: [String], isFavorite: Bool = false) {
            self.id = id
            self.name = name
            self.type = type
            self.shortDescription = shortDescription
            self.longDescription = longDescription
            self.preparationMinutes = preparationMinutes
            self.imageName = imageName
            self.ingredients = ingredients
            self.isFavorite = isFavorite
        }
}
