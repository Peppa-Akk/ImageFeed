import Foundation
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    weak var delegate: ImagesListCellDelegate?
    private var gradientInited = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}

// MARK: - change like
extension ImagesListCell {
    func setIsLiked(_ isLiked: Bool) {
        let likedImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likedImage, for: .normal)
    }
}

extension ImagesListCell {
    func configureGradient() {
        if !gradientInited {
            let gradient = CAGradientLayer()
            gradient.frame = gradientView.bounds
            gradient.colors = [UIColor.clear.cgColor, UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2).cgColor]
            gradientView.layer.insertSublayer(gradient, at: 0)
        }
        gradientInited.toggle()
    }
}
