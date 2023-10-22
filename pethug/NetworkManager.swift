//
//  NetworkManager.swift
//  pethug
//
//  Created by Raul Pena on 21/10/23.
//

import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = true
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            
            if path.status == .requiresConnection {
                print("status is requires conneciton: => \(path.status == .requiresConnection)")
            }
                if path.status == .satisfied {
                    print(" status is satisfied: =>          \(path.status == .satisfied)")
                }
                    if path.status == .unsatisfied {
                        print("status is unsatisfied: =>         \(path.status == .unsatisfied)")
                    }
            
            
            
            self?.isConnected = path.status == .satisfied
            
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}
