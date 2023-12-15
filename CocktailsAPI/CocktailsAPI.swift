import Foundation
import Combine

protocol CocktailsAPI: AnyObject {
    
    var cocktailsPublisher: AnyPublisher<Data, CocktailsAPIError> { get }
    func fetchCocktails(_ handler: @escaping (Result<Data, CocktailsAPIError>) -> Void)
}
