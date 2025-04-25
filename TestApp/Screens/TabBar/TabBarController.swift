import UIKit

class TabBarController: UIViewController {
    private let containerView = UIView()
    
    private lazy var tabBar: TabBar = {
        let tabBar = TabBar()
        tabBar.backgroundColor = UIColor(resource: .tabBarBackground)
        tabBar.delegate = self
        return tabBar
    }()
    
    private(set) var viewControllers: [TabBarItemCoordinatorType] = []
    private var currentViewController: UIViewController?
    private var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .tabBarBackground)
        view.addSubview(containerView)
        view.addSubview(tabBar)
        
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top)
        }
        
        tabBar.snp.remakeConstraints { make in
            make.height.equalTo(56)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setViewControllers(controllers: [TabBarItemCoordinatorType]) {
        viewControllers = controllers
        var tabBarButtons: [TabBarButton] = []
        
        controllers.forEach({
            guard let title = $0.tabBarItem.title, let image = $0.tabBarItem.image, let selectableImage = $0.tabBarItem.selectedImage  else { return }
            let tabBarButton: TabBarButton = TabBarButton()
            tabBarButton.item = TabBarItem(title: title, image: image, selectableImage: selectableImage)
            tabBarButtons.append(tabBarButton)
        })
        
        tabBar.setupButtons(tabBarButtons)
        showController(viewControllers[0])
    }
    
    func showController(_ controller: TabBarItemCoordinatorType) {
        if currentViewController != nil {
            currentViewController?.view.removeFromSuperview()
            currentViewController?.removeFromParent()
        }
        currentViewController = controller.rootController
        guard let rootController = controller.rootController else { return }
        
        addChild(rootController)
        containerView.insertSubview(rootController.view, at: 0)
        controller.rootController?.view.frame = containerView.bounds
        controller.rootController?.didMove(toParent: self)
    }
}

extension TabBarController: TabBarDelegate {
    func didSelectTab(index: Int) {
        guard selectedIndex != index else { return }
        self.selectedIndex = index
        showController(viewControllers[index])
        tabBar.setSelect(by: index)
    }
}
