import UIKit
import Kingfisher

//protocol WebViewControllerProtocol: AnyObject {
//    var presenter: WebViewPresenterProtocol? { get set }
//    func load(request: URLRequest)
//    func setProgressValue(_ newValue: Float)
//    func setProgressHidden(_ isHidden: Bool)
//}

protocol ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func updateProfileDetails(profile: Profile?)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    // MARK: - UI Varables
    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton = UIButton()
    
    // MARK: - Variables
    private let placeholderImage = UIImage(named: "person.crop.circle.fill")
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService = ProfileImageService.shared
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
        presenter?.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                self?.updateAvatar(notification: notification)
            })
    }
    
    @objc
    private func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo["URL"] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        
        updateAvatar(url: url)
    }
    
    func updateAvatar(url: URL) {
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url, placeholder: placeholderImage)
    }
    
    func updateProfileDetails(profile: Profile?) {
        if let profile {
            nameLabel.text = profile.name
            descriptionLabel.text = profile.bio
            loginNameLabel.text = profile.loginName
        } else {
            nameLabel.text = ""
            descriptionLabel.text = ""
            loginNameLabel.text = ""
            avatarImageView.image = placeholderImage
        }
    }
    
    @objc
    private func logoutButtonClicked() {
        presenter?.reset()
        
        let vc = SplashViewController()
        self.show(vc, sender: self)
    }
}

// MARK: - Extension UI-elements in code
extension ProfileViewController {
    // MARK: Button
    func addButtonOnView(_ button: UIButton) {
        button.setImage(UIImage(named: "logout_button.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.logoutButtonClicked), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45)
        ])
    }
    //MARK: ImageView
    func addImageViewOnView(_ imageView: UIImageView) {
        imageView.image = placeholderImage
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
    //MARK: Labels
    func addLabelOnView(_ label: UILabel,
                        with text: String,
                        by arrayConstraints: [NSLayoutConstraint],
                        red: CGFloat, green: CGFloat, blue:
                        CGFloat, font: UIFont) {
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.textColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate(arrayConstraints)
    }
}

// MARK: Add UI-Elements on View
extension ProfileViewController {
    func layout() {
        view.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        
        addButtonOnView(logoutButton)
        let gradient = CAGradientLayer()
        gradient.frame = avatarImageView.bounds
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 35
        gradient.masksToBounds = true
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
        avatarImageView.layer.addSublayer(gradient)
        
        addImageViewOnView(avatarImageView)
        addLabelOnView(nameLabel, with: "Екатерина Новикова",
                       by: [nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
                            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
                            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)],
                       red: 255, green: 255, blue: 255, font: UIFont.boldSystemFont(ofSize: 23))
        gradient.frame = nameLabel.bounds
        nameLabel.layer.addSublayer(gradient)

        addLabelOnView(loginNameLabel, with: "@ekaterina_nov",
                       by: [loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
                            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                            loginNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)],
                       red: 174, green: 175, blue: 180, font: UIFont.systemFont(ofSize: 13))
        gradient.frame = loginNameLabel.bounds
        loginNameLabel.layer.addSublayer(gradient)

        addLabelOnView(descriptionLabel, with: "Hello, world!",
                       by: [descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
                            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
                            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)],
                       red: 255, green: 255, blue: 255, font: UIFont.systemFont(ofSize: 13))
        gradient.frame = descriptionLabel.bounds
        descriptionLabel.layer.addSublayer(gradient)
    }
}
