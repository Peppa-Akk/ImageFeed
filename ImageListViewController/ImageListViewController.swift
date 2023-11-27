@testable import ImageFeed
import XCTest
import Foundation

final class ImageListViewController: XCTestCase {
    
    //MARK: - testImageViewControllerCallsViewDidLoad
    func testImageViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let presenter = ImageViewPresenterSpy()
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    //MARK: - testImageViewControllerCallsFetchFromViewDidLoad
    func testImageViewControllerCallsFetchFromViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let presenter = ImageViewPresenterSpy()
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.fetchPhotoNextPageCalled)
    }
    
    //MARK: - testUpdatePhotoNotEqual
    func testUpdatePhotoNotEqual() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let presenter = ImageViewPresenterSpy()
        let viewController = ImageViewControllerSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        Service.shared.photos.append(Photo(
            id: "A",
            size: CGSize(),
            createdAt: Date(),
            welcomeDescription: "S",
            thumbImageURL: "D",
            largeImageURL: "G",
            isLiked: true
        ))
        
        //then
        XCTAssertNotEqual(Service.shared.photos.count, viewController.photos.count)
    }
    
    //MARK: - testUpdatePhotoEqual
    func testUpdatePhotoEqual() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let presenter = ImageViewPresenterSpy()
        let viewController = ImageViewControllerSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.presenter?.updatesPhotos()
        
        //then
        XCTAssertEqual(Service.shared.photos.count, viewController.photos.count)
    }
    
    //MARK: - testUpdatePhotoEqualWithUpdateTableAnimated
    func testUpdatePhotoEqualWithUpdateTableAnimated() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let presenter = ImageViewPresenterSpy()
        let viewController = ImageViewControllerSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.view?.updateTableViewAnimated()
        
        //then
        XCTAssertEqual(Service.shared.photos.count, viewController.photos.count)
    }
    
    //MARK: - testImageListCellDidTapLikeCalls
    func testImageListCellDidTapLikeCalls() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let presenter = ImageViewPresenterSpy()
        let viewController = ImageViewControllerSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.presenter?.imageListCellDidTapLike(ImagesListCell())
        
        //then
        XCTAssertTrue(presenter.imageListCellDidTapLikeCalled)
    }
}

//MARK: - ImageViewControllerSpy
final class ImageViewControllerSpy: ImageListViewControllerProtocol {
    var presenter: ImageFeed.ImageListPresenterProtocol?
    var updateTableViewAnimatedCalled: Bool = false
    
    var photos: [Photo] = []
    
    var tableView: UITableView!
    
    func updateTableViewAnimated() {
        presenter?.updatesPhotos()
    }
    
    
}

//MARK: - ImageViewPresenterSpy
final class ImageViewPresenterSpy: ImageListPresenterProtocol {
    var view: ImageFeed.ImageListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var fetchPhotoNextPageCalled: Bool = false
    var imageListCellDidTapLikeCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled.toggle()
        fetchPhotoNextPage()
    }
    
    func fetchPhotoNextPage() {
        fetchPhotoNextPageCalled.toggle()
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell) {
        if cell is ImagesListCell {
            imageListCellDidTapLikeCalled.toggle()
        }
    }
    
    func updatesPhotos() {
        guard let view = view else { return }
        view.photos = Service.shared.photos
    }
}

//MARK: - Service
final class Service {
    static let shared = Service()
    
    var photos: [Photo] = [Photo(
        id: "A",
        size: CGSize(),
        createdAt: Date(),
        welcomeDescription: "S",
        thumbImageURL: "D",
        largeImageURL: "G",
        isLiked: true
    )]
}
