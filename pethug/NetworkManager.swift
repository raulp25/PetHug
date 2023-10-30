//
//  NetworkManager.swift
//  pethug
//
//  Created by Raul Pena on 21/10/23.
//

import Network

final class NetworkMonitor {
    public static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = true
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    public func connect() {
        isConnected = true
    }
    
    public func disconnect() {
        isConnected = false
    }
}
