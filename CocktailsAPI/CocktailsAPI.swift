import Foundation
import Combine

protocol CocktailsAPI {
    func fetchCocktails(completion: @escaping (Result<[Cocktail], Error>) -> Void)
}
