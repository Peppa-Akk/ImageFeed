import Foundation

fileprivate let DefaultBaseURL = URL(string: "https://api.unsplash.com")!

// MARK: - OAuth2Service
final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private let storage: OAuth2TokenStorage
    private let builder: URLRequestBuilder
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    init(storage: OAuth2TokenStorage = .shared, builder: URLRequestBuilder = .shared) {
        self.storage = storage
        self.builder = builder
    }
    
    var isAuthenticated: Bool {
        storage.token != nil
    }
    
    func fetchAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTast(for: request) {
            [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.storage.token = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

// MARK: - Extension OAuth2Service
extension OAuth2Service {
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURL)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMetod: "POST",
            baseURL: "https://unsplash.com"
        )
    }
}
