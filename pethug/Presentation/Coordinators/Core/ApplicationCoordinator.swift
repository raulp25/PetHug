//
//  ApplicationCoordinator.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Combine
import UIKit

final class ApplicationCoordinator: Coordinator {
    
    var rootViewController: UINavigationController = .init()
    
    var childCoordinators: [StateCoordinator] = [StateCoordinator]()
    
    private let window: UIWindow
    
    private var authService: AuthServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    @Published private var session: SessionState = .signedOut
    
    //MARK: - init
    init(window: UIWindow, authService: AuthServiceProtocol) {
        self.window = window
        self.authService = authService
    }
    
    
    //MARK: - Setup / listen
    func start() {
        window.rootViewController = LaunchViewController()
    }
    
    
}
