import Foundation

let accessKey = "G0ICV6jHLk1CzQjh_xPpNyXjCL4WzIe5yMuEfL4sszo"
//let accessKey = "VoYzJfYCfsXIE7wgekIl0M1eg4xRWn-LOX1JU4r6VDY"
let secretKey = "2LgMZErsMb91ZXCw84zSUzNT1k5WoTZ81Lrat0oGbKw"
//let secretKey = "elYXJopEO8ebHy2OSuX-5dnipCTJ3X__ru640a7l9fI"
let redirectURL = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"

let defaultBaseURL = URL(string: "https://api.unsplash.com")!
let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let authAccessKey: String
    let authSecretKey: String
    let authRedirectURI: String
    let authAccessScope: String
    let authDefaultBaseURL: URL
    let authAuthURLString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         authURLString: String,
         defaultBaseURL: URL
    ) {
        self.authAccessKey = accessKey
        self.authSecretKey = secretKey
        self.authRedirectURI = redirectURI
        self.authAccessScope = accessScope
        self.authDefaultBaseURL = defaultBaseURL
        self.authAuthURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: accessKey,
                                 secretKey: secretKey,
                                 redirectURI: redirectURL,
                                 accessScope: accessScope,
                                 authURLString: unsplashAuthorizeURLString,
                                 defaultBaseURL: defaultBaseURL)
    }
}
