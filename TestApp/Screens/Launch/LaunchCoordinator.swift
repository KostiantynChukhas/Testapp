import UIKit

protocol LaunchCoordinatorTransitions: AnyObject {
    func launchFinished()
}

class LaunchCoordinator {
    
    private weak var transitions: LaunchCoordinatorTransitions?
    private let window: UIWindow
    
    init(window: UIWindow,
         transitions: LaunchCoordinatorTransitions?) {
        self.window = window
        self.transitions = transitions
    }
}

extension LaunchCoordinator {
    func start() {
        let model = LaunchViewModel(self)
        let controller = LaunchViewController(viewModel: model)
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func dismiss() {
        self.transitions?.launchFinished()
    }
}
