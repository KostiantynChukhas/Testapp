import UIKit

class UsersCoordinator: TabBarItemCoordinatorType {
    var tabBarItem: UITabBarItem
    var rootController: UIViewController?
    
    weak var navigationController: UINavigationController?
    weak var viewController: UIViewController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.tabBarItem = UITabBarItem(title: "Users", image: UIImage(resource: .usersLogo), selectedImage: nil)

        let model = UsersViewModel(self)
        let controller = UsersViewController(viewModel: model)
        self.rootController = controller
    }
}
