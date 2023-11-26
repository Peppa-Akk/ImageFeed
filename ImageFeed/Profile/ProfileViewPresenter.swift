import Foundation
import UIKit

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func reset()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        updateAvatar()
        updateProfie()
    }
    
    func reset() {
        CookieService.clean()
        OAuth2TokenStorage().cleanToken()
    }
}

extension ProfileViewPresenterProtocol {
    func updateAvatar() {
        guard let url = ProfileImageService.shared.avatarURL else { return }
        
        view?.updateAvatar(url: url)
    }
    
    func updateProfie() {
        guard let profile = ProfileService.shared.profile else { return }
        
        view?.updateProfileDetails(profile: profile)
    }
}
