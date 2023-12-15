import Foundation

enum CocktailsAPIError: Error, LocalizedError {
    case unavailable
    
    var errorDescription: String? {
        return "Unable to retrieve cocktails, API unavailable"
    }
}
