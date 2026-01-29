import Network
import SwiftUI

// An enum to handle the network status
enum NetworkStatus: String {
    case connected
    case disconnected
}

class NetworkReachability: ObservableObject {
    static let shared = NetworkReachability()
    let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    var path: NWPath?
    @Published var status: NetworkStatus = .connected

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.path = path
            // Monitor runs on a background thread so we need to publish
            // on the main thread
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("We're connected!")
                    self.status = .connected

                } else {
                    print("No connection.")
                    self.status = .disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    public func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
    }
}
