import Foundation
import Combine

class FakeCocktailsAPI: CocktailsAPI {
    
    enum CocktailAPIFailure {
        case never
        case count(UInt)
    }
    
    private let queue = DispatchQueue(label: "CocktailsAPI")
    private let jsonData: Data
    private var failure: CocktailAPIFailure
    
    init(withFailure failure: CocktailAPIFailure = .never) {
        guard let file = Bundle.main.url(forResource: "sample", withExtension: "json") else {
            fatalError("sample.json can not be found")
        }
        guard let data = try? Data(contentsOf: file) else {
            fatalError("can not load contents of sample.json")
        }
        jsonData = data
        self.failure = failure
    }
    
    func fetchCocktails(completion: @escaping (Result<[Cocktail], Error>) -> Void) {
        if case let .count(count) = failure {
            failure = count - 1 == 0 ? .never : .count(count - 1)
            queue.async {
                completion(.failure(CocktailsAPIError.unavailable))
            }
            return
        }
        let data = jsonData
        print(jsonData)
        queue.async {
            do {
                let cocktails = try JSONDecoder().decode([Cocktail].self, from: data)
                completion(.success(cocktails))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
    }
}
