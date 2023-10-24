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
        bindAuthChangesToSession()
        
        $session
            .handleThreadsOperator()
            .map({ [weak self] state -> AnyPublisher<SessionState, Never> in
                if let splash = self?.window.rootViewController as? LaunchViewController {
                    return Just(state)
                        .delay(
                            for: .seconds(splash.countDown),
                            scheduler: RunLoop.main
                        )
                        .eraseToAnyPublisher()
                } else {
                    return Just(state)
                        .eraseToAnyPublisher()
                }
            })
            .switchToLatest()
            .sink { [weak self] state in
                self?.setUpCoordinator(with: state)
            }.store(in: &cancellables)
    }
    
    //MARK: - Private methods
    private func setUpCoordinator(with state: SessionState) {
        var childCoordinator: StateCoordinator?
        switch state {
        case .signedOut:
            let coordinator = LoginCoordinator()
            window.rootViewController = coordinator.rootViewController
            childCoordinator = coordinator
        case .signedInButNotVerified:
            //states signedInButNotVerified and signedIn are the same,
            //we have them both in case we add another flow when user email is not verified
            let coordinator = InAppCoordinator()
            window.rootViewController = coordinator.rootViewController
            childCoordinator = coordinator
        case .signedIn:
            let coordinator = InAppCoordinator()
            window.rootViewController = coordinator.rootViewController
            childCoordinator = coordinator
        }
        
        guard let childCoordinator else { return }
        childCoordinator.parentCoordinator = self
        childCoordinator.start()
        childCoordinators.removeAll()
        childCoordinators.append(childCoordinator)
    }
    
    
    
    //MARK: - bind
    private func bindAuthChangesToSession() {
        authService
            .observeAuthChanges()
            .assign(to: &$session)
    }
    
}
