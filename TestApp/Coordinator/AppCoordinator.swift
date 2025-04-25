import Foundation
import UIKit

class AppCoordinator {
    
    var window: UIWindow
    private let serviceHolder = ServiceHolder.shared
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        startInitialServices()
        showSplash()
    }
    
    private func showSplash() {
        let coordinator = LaunchCoordinator(window: window, transitions: self)
        coordinator.start()
    }
}

extension AppCoordinator: LaunchCoordinatorTransitions {
    func launchFinished() {
        print(#function)
        let coordinator = TabBarCoordinator(window: window)
        coordinator.start()
    }
}

extension AppCoordinator {
    
    private func startInitialServices() {
        serviceHolder.add(UserService.self, for: UserService())
    }
}
