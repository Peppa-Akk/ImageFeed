//
//  ViewController.swift
//  ImageFeed
//
//  Created by Александр Хасеневич on 25.09.23.
//

import UIKit

final class ImagesListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Variables
    private let imageListService = ImageListService.shared
    private var imageServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenter?
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
    private var photos: [Photo] = []
    private let placeholderImage = UIImage(named: "stub")
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                self?.updateTableViewAnimated()
            })
        
        imageListService.fetchPhotoNextPage()
    }
    
    // MARK: - Functions
    func configCell(for cell: ImagesListCell, with photo: Photo) {
        // set image
        if let url = URL(string: photo.thumbImageURL) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url, placeholder: placeholderImage)
        }
        // set like
        let likedImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likedImage, for: .normal)
        
        cell.configureGradient()
        
        //set date
        if let date = photo.createdAt {
            let textDate = dateFormatter.string(from: date)
            cell.dateLabel.text = textDate
        } else {
            cell.dateLabel.text = ""
        }
    }
    
    // MARK: - Override Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showSingleImageSegueIdentifier,
              let viewController = segue.destination as? SingleImageViewController,
              let indexPath = sender as? IndexPath  else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        if let url = URL(string: photos[indexPath.row].largeImageURL) {
            viewController.largeImageURL = url
        }
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - Extension DataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        imageListCell.delegate = self
        imageListCell.configureGradient()
        
        configCell(for: imageListCell, with: photos[indexPath.row])
        return imageListCell
    }
}

// MARK: - Extension UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.bottom + imageInsets.top
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotoNextPage()
        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.photos = self.imageListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

// MARK: - extension showAlert func
extension ImagesListViewController {
    private func showAlert(error: Error) {
        alertPresenter?.showAlert(tittle: "Что-то пошло не так :(",
                                  message: "Не удалось войти в систему, \(error.localizedDescription)") {
        }
    }
}
