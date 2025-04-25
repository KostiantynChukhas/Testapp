import UIKit

protocol TabBarItemCoordinatorType {
    var rootController: UIViewController? { get }
    var tabBarItem: UITabBarItem { get }
}

class TabBarCoordinator {
    enum Route {
        case `self`
    }
    
    private var tabCoordinators: [TabBarItemCoordinatorType] = []
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
}

// MARK: - Navigation -
extension TabBarCoordinator {
    func start() {
        DispatchQueue.main.async{
            let controller: TabBarController = TabBarController()
            let root = UINavigationController(rootViewController: controller)
            root.setNavigationBarHidden(true, animated: false)
            self.window.rootViewController = root
            self.window.makeKeyAndVisible()
            
            let firstTabCoord = UsersCoordinator(navigationController: root)
            let secondTabCoord = SignUpCoordinator(navigationController: root)
            
            self.tabCoordinators = [firstTabCoord, secondTabCoord]
            controller.setViewControllers(controllers: self.tabCoordinators)
        }
    }
}

