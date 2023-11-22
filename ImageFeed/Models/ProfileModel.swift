import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
        case profileImage = "profile_image"
    }
}

extension Profile {
    init(_ profile: ProfileResult) {
        self.init(
            username: profile.username,
            name: "\(profile.firstName) \(profile.lastName ?? "")",
            loginName: "@\(profile.username)",
            bio: profile.bio ?? ""
        )
    }
}
