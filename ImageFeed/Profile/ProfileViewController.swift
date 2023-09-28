import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Varables
    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton = UIButton()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Add UI-Elements on View
        addButtonOnView(logoutButton)
        addImageViewOnView(avatarImageView)
        addLabelOnView(nameLabel, with: "Екатерина Новикова",
                       by: [nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
                            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
                            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)],
                       red: 255, green: 255, blue: 255, font: UIFont.boldSystemFont(ofSize: 23))

        addLabelOnView(loginNameLabel, with: "@ekaterina_nov",
                       by: [loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
                            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                            loginNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)],
                       red: 174, green: 175, blue: 180, font: UIFont.systemFont(ofSize: 13))

        addLabelOnView(descriptionLabel, with: "Hello, world!",
                       by: [descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
                            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
                            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)],
                       red: 255, green: 255, blue: 255, font: UIFont.systemFont(ofSize: 13))
    }
}

// MARK: - Extension UI-elements in code
extension ProfileViewController {
    // MARK: Button
    func addButtonOnView(_ button: UIButton) {
        button.setImage(UIImage(named: "logout_button.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        imageView.image = UIImage(named: "avatar.png")
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
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
    func addLabelOnView(_ label: UILabel, with text: String, by arrayConstraints: [NSLayoutConstraint], red: CGFloat, green: CGFloat, blue: CGFloat, font: UIFont) {
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.textColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate(arrayConstraints)
    }
}


//        nameLabel.text = "Екатерина Новикова"
//        nameLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(nameLabel)
//
//        NSLayoutConstraint.activate([
//            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
//            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8)
//        ])

//        loginNameLabel.text = "@ekaterina_nov"
//        loginNameLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
//        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(loginNameLabel)
//
//        NSLayoutConstraint.activate([
//            loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
//            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
//        ])

//        descriptionLabel.text = "Hello, world!"
//        descriptionLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
//        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(descriptionLabel)
//        NSLayoutConstraint.activate([
//            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
//            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8)
//        ])
