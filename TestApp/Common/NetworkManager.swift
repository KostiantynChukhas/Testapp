import Network
import UIKit

class NetworkManager {
    static let shared = NetworkManager()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    var isConnected: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            if !self.isConnected {
                DispatchQueue.main.async {
                    AlertHelper.showAlert(.internet)
                }
            }
        }
        monitor.start(queue: queue)
    }

}
