import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
        }
        
        NetworkManager.shared.startMonitoring()
        return true
    }

}

