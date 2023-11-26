import Foundation

//protocol ProfileViewPresenterProtocol {
//    var view: ProfileViewControllerProtocol? { get set }
//    func viewDidLoad()
//    func reset()
//}

protocol ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotoNextPage()
    func imageListCellDidTapLike(_ cell: ImagesListCell)
    func updatesPhotos()
}

final class ImageListPresenter: ImageListPresenterProtocol {
    weak var view: ImageListViewControllerProtocol?
    
    func viewDidLoad() {
        setupObserver()
        fetchPhotoNextPage()
    }
    
    func fetchPhotoNextPage() {
        ImageListService.shared.fetchPhotoNextPage()
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let view = view,
              let indexPath = view.tableView.indexPath(for: cell) else { return }
        let photo = view.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        ImageListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                view.photos = ImageListService.shared.photos
                cell.setIsLiked(view.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func updatesPhotos() {
        guard let view = view else { return }
        let oldCount = view.photos.count
        let newCount = ImageListService.shared.photos.count
        view.photos = ImageListService.shared.photos
        
        if oldCount != newCount {
            view.tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                view.tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImageListPresenter {
    func setupObserver() {
        NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                self?.view?.updateTableViewAnimated()
            })
    }
}
