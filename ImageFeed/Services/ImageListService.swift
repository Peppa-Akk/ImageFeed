import Foundation

final class ImageListService {
    static let shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlBuilder = URLRequestBuilder.shared
    private var currentTask: URLSessionTask?
    private var currentLikeTask: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let imagesPerPage = 10
//    private var 
    
    func fetchPhotoNextPage() {
        assert(Thread.isMainThread)
        
        currentTask?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        guard let request = makeRequest(with: nextPage) else {
            assertionFailure("Invalid request")
            return
        }
        let session = URLSession.shared
        let task = session.objectTast(for: request) {
            [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            self.currentTask = nil
            switch result {
            case .success(let photoResult):
                for photo in photoResult {
                    photos.append(convert(by: photo))
                }
                self.lastLoadedPage = nextPage
                
                NotificationCenter.default.post(
                    name: ImageListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": photos]
                )
            case .failure:
                break
            }
        }
        
        self.currentTask = task
        task.resume()
    }
    
    private func makeRequest(with page: Int) -> URLRequest? {
        urlBuilder.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)"
            + "&&per_page\(imagesPerPage)",
            httpMetod: "GET",
            baseURL: "https://api.unsplash.com")
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        currentLikeTask?.cancel()
        
        let likeMethod = isLike ? "POST" : "DELETE"
        
        guard let request = makeLikeRequest(
            for: photoId,
            with: likeMethod
        ) else {
            assertionFailure("Invalid request")
            return
        }
        let session = URLSession.shared
        let task = session.objectTast(for: request) {
            [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            self.currentLikeTask = nil
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                    
                    NotificationCenter.default.post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": photos]
                    )
                    
                    let likeByUser = photo.isLiked
                    completion(.success(likeByUser))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        self.currentLikeTask = task
        task.resume()
    }
    
    private func makeLikeRequest(for id: String, with method: String) -> URLRequest? {
        urlBuilder.makeHTTPRequest(
            path: "/photos/\(id)/like",
            httpMetod: method,
            baseURL: "https://api.unsplash.com")
    }
}

extension ImageListService {
    private func convert(by photoResult: PhotoResult) -> Photo {
        return Photo(
            id: photoResult.id,
            size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)),
            createdAt: ISO8601DateFormatter().date(
                from: photoResult.createdAt ?? DateFormatter().string(from: Date())
            ),
            welcomeDescription: photoResult.descriptiom ?? "",
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser
        )
    }
}
