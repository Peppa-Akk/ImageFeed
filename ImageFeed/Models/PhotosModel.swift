import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let descriptiom: String?
    let urls: UrlsResult
    let likedByUser: Bool
}

struct UrlsResult: Codable {
    let full: String
    let thumb: String
}
