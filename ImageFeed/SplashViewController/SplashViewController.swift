import UIKit

// MARK: - SplashViewController
final class SplashViewController: UIViewController {
    
    // MARK: - Variables
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private var alertPresenter: AlertPresenter?
    
    // MARK: - override funcs
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
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    //MARK: - funcs
    private func switchToTabBarController() {
        guard
            let window = UIApplication.shared.windows.first else { fatalError("Failed Congigaruration!") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
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

// MARK: - extension override prepare
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - extension funcs fetchAuthToken and fetchProfile
extension SplashViewController {
    private func fetchAuthToken(_ code: String) {
        OAuth2Service.shared.fetchAuthToken(code: code) { [weak self] authResult in
            guard let self = self else { return }
            switch authResult {
            case .success:
                self.fetchProfile {
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(let error):
                self.showAlert(error: error)
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func fetchProfile(completion: @escaping () -> Void) {
        ProfileService.shared.fetchProfile { [weak self] profileResult in
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
        UIBlockingProgressHUD.show()
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            self.fetchAuthToken(code)
        }
    }
}
