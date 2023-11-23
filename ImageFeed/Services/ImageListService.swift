import Foundation

final class ImageListService {
    static let shared = ImageListService()
    static let didChengeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlBuilder = URLRequestBuilder.shared
    private var currentTask: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let imagesPerPage = 10
//    private var 
    
    private func fetchPhotoNextPage() {
        assert(Thread.isMainThread)
        
        currentTask?.cancel()
        
        guard let request = makeRequest() else {
            assertionFailure("Invalid request")
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTast(for: request) {
            [weak self] (result: Result<PhotoResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let body):
                
                // From PhotoResult to Photo and append to photos [Photo]
                
                self.currentTask = nil
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": photos]
                )
            case .failure:
                break
            }
            self.currentTask = nil
        }
        
        self.currentTask = task
        task.resume()
    }
    
    private func makeRequest() -> URLRequest? {
        urlBuilder.makeHTTPRequest(
            path: "/photos"
            + "?page=\(lastLoadedPage)" // ??
            + "&&per_page\(imagesPerPage)",
            httpMetod: "GET",
            baseURL: "https://api.unsplash.com")
    }
}
