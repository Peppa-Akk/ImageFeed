import Foundation

// MARK: protocol Profile
//protocol ProfileProtocol: AnyObject {
//    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
//}

final class ProfileService {
    static let shared = ProfileService()
    
    private let builder: URLRequestBuilder
    
    private(set) var profile: Profile?
    private var currentTask: URLSessionTask?
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        currentTask?.cancel()
        
        guard let request = makeFetchProfileRequest() else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        currentTask = URLSession.shared.objectTast(for: request) { 
            [weak self] (result: Result<ProfileResult, Error>) in
            self?.currentTask = nil
            switch result {
            case .success(let profileResult):
                let profile = Profile(profileResult)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeFetchProfileRequest() -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/me",
            httpMetod: "GET",
            baseURL: "https://api.unsplash.com"
        )
    }
}
