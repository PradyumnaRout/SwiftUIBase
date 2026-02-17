//
//  NetworkMonitor.swift
//  DropShop
//
//  Created by hb on 13/02/26.
//
import Network
import SwiftUI

@Observable
class NetworkMonitor {
    var isConnected: Bool?
    var connectionType: NWInterface.InterfaceType?
    
    init() {
        startMonitoring()
    }
    
    /// - Monitor properties
    private let queue = DispatchQueue(label: "monitor_network")
    private let monitor = NWPathMonitor()
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
                
                let types: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet, .loopback]
                self.connectionType = types.first(where: { path.usesInterfaceType($0) })
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        stopMonitoring()
    }
    
    private func stopMonitoring() {
        monitor.cancel()
    }
}
