import UIKit

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    func showAlert(tittle: String, message: String, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: tittle,
                                      message: message,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            handler()
        }
        alert.addAction(alertAction)
        delegate?.present(alert, animated: true)
    }
}

