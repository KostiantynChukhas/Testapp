import UIKit

final class AlertHelper {
    
    static func showAlert(_ type: AlertType) {
        guard let topVC = topMostViewController() else { return }
        hideAlertView(from: topVC)
        
        DispatchQueue.main.async {
            let view = AlertView(frame: topVC.view.bounds)
            view.backgroundColor = .white
            if !topVC.view.subviews.contains(where: { $0 is AlertView }) {
                topVC.view.addSubview(view)
            }
            view.configure(type)
        }
    }

    private static func hideAlertView(from viewController: UIViewController) {
        DispatchQueue.main.async {
            let alertViews = viewController.view.subviews.compactMap { $0 as? AlertView }
            alertViews.forEach { $0.removeFromSuperview() }
        }
    }

    static func topMostViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topMostViewController(base: selected)
        }

        if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }

        return base
    }
}
