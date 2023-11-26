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
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case descriptiom = "description"
        case urls = "urls"
        case likedByUser = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let full: String
    let thumb: String
}

struct LikeResult: Codable {
    let isLike: Bool
    
    enum CodingKeys: String, CodingKey {
        case isLike = "liked_by_user"
    }
}
