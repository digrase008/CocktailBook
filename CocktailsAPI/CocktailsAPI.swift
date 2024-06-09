import Foundation
import Combine

protocol CocktailsAPI: AnyObject {
    
    var cocktailsPublisher: AnyPublisher<[Cocktail], CocktailsAPIError> { get } //Data
    func fetchCocktails(_ handler: @escaping (Result<Data, CocktailsAPIError>) -> Void)
}
