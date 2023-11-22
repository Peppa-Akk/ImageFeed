import Foundation

final class URLRequestBuilder {
    static let shared = URLRequestBuilder()
    
    private let storage: OAuth2TokenStorage
    
    init(storage: OAuth2TokenStorage = .shared) {
        self.storage = storage
    }
    
    func makeHTTPRequest(
        path: String,
        httpMetod: String,
        baseURL: String
    ) -> URLRequest? {
        guard
            let url = URL(string: baseURL),
            let baseUrl = URL(string: path, relativeTo: url)
        else { return nil }
        
        var request = URLRequest(url: baseUrl)
        request.httpMethod = httpMetod
        
        if let token = storage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
