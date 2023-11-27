@testable import ImageFeed
import XCTest
import Foundation

final class ProfileViewControllerTests: XCTestCase {
    //MARK: - testProfileViewControllerCallsViewDidLoad
    func testProfileViewControllerCallsViewDidLoad() {
        //given
        let profileViewPresenter = ProfileViewPresenterSpy()
        let profileViewController = ProfileViewController()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        
        //when
        _ = profileViewController.view
        
        //then
        XCTAssertTrue(profileViewPresenter.viewDidLoadCalled)
    }
    
    //MARK: - testResetCalled
    func testResetFromTokenStorage() {
        //given
        let profileViewPresenter = ProfileViewPresenterSpy()
        let profileViewController = ProfileViewController()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        
        //when
        profileViewPresenter.reset()
        
        //then
        XCTAssertFalse(profileViewPresenter.tokenStorage)
    }
    
    //MARK: - testInputDataURLWithAvatarUpdateCalled
    func testInputDataURLWithAvatarUpdateCalled() {
        //given
        let profileViewPresenter = ProfileViewPresenterSpy()
        let profileViewController = ProfileViewControllerSpy()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        
        Service.shared.avatar = URL(string: "https://unsplash.com/oauth/authorize/native")
        
        //when
        profileViewController.presenter?.viewDidLoad()
        
        //then
        XCTAssertTrue(profileViewController.updateAvatarCalled)
    }
    
    //MARK: - testInputDataProfileWithUpdateProfileDetailsCalled
    func testInputDataProfileWithUpdateProfileDetailsCalled() {
        //given
        let profileViewPresenter = ProfileViewPresenterSpy()
        let profileViewController = ProfileViewControllerSpy()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        
        Service.shared.profile = Profile(
            ProfileResult(
            username: "A",
            firstName: "S",
            lastName: "D",
            bio: "F",
            profileImage: ProfileImage(small: "Q", medium: "W", large: "E")))
        
        //when
        profileViewController.presenter?.viewDidLoad()
        
        //then
        XCTAssertTrue(profileViewController.updateProfileCalled)
    }
}

//MARK: - ProfileViewPresenterSpy
final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var updateAvatarCalled: Bool = false
    var updateProfileCalled: Bool = false
    var tokenStorage: Bool = true
    
    func viewDidLoad() {
        viewDidLoadCalled.toggle()
        updateAvatar()
        updateProfile()
    }
    
    func reset() {
        tokenStorage.toggle()
    }
    
    func updateAvatar() {
        updateAvatarCalled.toggle()
        guard let url = Service.shared.avatar else { return }
        view?.updateAvatar(url: url)
    }
    
    func updateProfile() {
        updateProfileCalled.toggle()
        guard let profile = Service.shared.profile else { return }
        view?.updateProfileDetails(profile: profile)
    }
}

//MARK: - ProfileViewControllerSpy
final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var updateAvatarCalled: Bool = false
    var updateProfileCalled: Bool = false
    
    func updateAvatar(url: URL) {
        updateAvatarCalled.toggle()
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        updateProfileCalled.toggle()
    }
}

final class Service {
    static let shared = Service()
    
    var profile: Profile?
    var avatar: URL?
}
