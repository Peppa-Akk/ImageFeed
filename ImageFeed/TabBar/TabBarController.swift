import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListPresenter = ImageListPresenter()
        let profileViewPresenter = ProfileViewPresenter()
        
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            fatalError("Failed to prepare for ImagesListViewController")
        }
        imagesListViewController.presenter = imageListPresenter
        imageListPresenter.view = imagesListViewController
        
        let profileViewController = ProfileViewController()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
