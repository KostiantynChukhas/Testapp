import UIKit

class SignUpCoordinator: TabBarItemCoordinatorType {
    var tabBarItem: UITabBarItem
    var rootController: UIViewController?
    
    weak var navigationController: UINavigationController?
    weak var viewController: UIViewController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.tabBarItem = UITabBarItem(title: "Sign up", image: UIImage(resource: .signUp), selectedImage: nil)

        let model = SignUpViewModel(self)
        let controller = SignUpViewController(viewModel: model)
        self.rootController = controller
    }
}
