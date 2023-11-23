import UIKit

// MARK: - SplashViewController
final class SplashViewController: UIViewController {
    
    // MARK: - Variables
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    private var unsplashLogoImage = UIImageView()
    
    private var alertPresenter: AlertPresenter?
    
    // MARK: - override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2Service.shared.isAuthenticated {
            UIBlockingProgressHUD.show()
            fetchProfile {
                UIBlockingProgressHUD.dismiss()
            }
        } else {
            switchToAuthViewController()
        }
    }
    
    //MARK: - funcs
    private func layout() {
        view.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        unsplashLogoImage.image = UIImage(named: "logo")
        view.addSubview(unsplashLogoImage)
        
        NSLayoutConstraint.activate([
            unsplashLogoImage.widthAnchor.constraint(equalToConstant: 75),
            unsplashLogoImage.heightAnchor.constraint(equalToConstant: 77.68),
            unsplashLogoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            unsplashLogoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0)
        ])
    }
}

// MARK: - extension switch VC funcs
extension SplashViewController {
    private func switchToTabBarController() {
        guard
            let window = UIApplication.shared.windows.first else { fatalError("Failed Congigaruration!") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarVC")
        window.rootViewController = tabBarController
    }
    
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: .main
        )
        let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
        guard let viewController = viewController as? AuthViewController else { return }
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false)
    }
}

// MARK: - extension showAlert func
extension SplashViewController {
    private func showAlert(error: Error) {
        alertPresenter?.showAlert(tittle: "Что-то пошло не так :(",
                                  message: "Не удалось войти в систему, \(error.localizedDescription)") {
            self.performSegue(withIdentifier: self.showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
}

// MARK: - extension funcs fetchAuthToken, fetchProfile and fetchProfileImage
extension SplashViewController {
    private func fetchAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchAuthToken(code: code) { [weak self] authResult in
            guard let self = self else { return }
            switch authResult {
            case .success:
                self.fetchProfile {
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.showAlert(error: error)
                break
            }
        }
    }
    
    private func fetchProfile(completion: @escaping () -> Void) {
        ProfileService.shared.fetchProfile { [weak self] profileResult in
            guard let self = self else { return }
            switch profileResult {
            case .success(let profile):
                let profileUsername = profile.username
                self.fetchProfileImage(username: profileUsername) {
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(let error):
                self.showAlert(error: error)
            }
            completion()
        }
    }
    
    private func fetchProfileImage(username: String, completion: @escaping () -> Void) {
        ProfileImageService.shared.fetchProfileImageURL(userName: username) { [weak self] profileResult in
            guard let self = self else { return }
            switch profileResult {
            case .success:
                self.switchToTabBarController()
            case .failure(let error):
                self.showAlert(error: error)
            }
            completion()
        }
    }
}

// MARK: - extension AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchAuthToken(code)
        }
    }
}
