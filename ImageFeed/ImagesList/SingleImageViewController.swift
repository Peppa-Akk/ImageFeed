import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    
    //MARK: - Variables
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            guard let image else { return }
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    var largeImageURL: URL?
    
    //MARK: - Outlets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    //MARK: - Actions
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(activityItems: [image as Any],
                                             applicationActivities: nil)
        present(share, animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        loadImage()
        
        guard let image else { return }
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    //MARK: Funtions
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
}

// MARK: - Extension UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: - loadImage
extension SingleImageViewController {
    func loadImage() {
        UIBlockingProgressHUD.show()
        guard let image = largeImageURL else { return }
        imageView.kf.setImage(with: image) { [weak self] imageResult in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch imageResult {
            case .success(let result):
                self.image = result.image
                self.rescaleAndCenterImageInScrollView(image: result.image)
            case .failure:
                break
            }
        }
    }
}
