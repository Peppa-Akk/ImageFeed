import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let keychainWrapper = KeychainWrapper.standard
    private let tokenKey = "token"
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                keychainWrapper.set(token, forKey: tokenKey)
            } else {
                keychainWrapper.removeObject(forKey: tokenKey)
            }
        }
    }
    
    func cleanToken() {
        keychainWrapper.removeObject(forKey: tokenKey)
    }
}
