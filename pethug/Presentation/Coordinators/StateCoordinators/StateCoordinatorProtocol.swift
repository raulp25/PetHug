//
//  StateCoordinatorProtocol.swift
//  pethug
//
//  Created by Raul Pena on 13/09/23.
//

import Foundation

protocol StateCoordinator: Coordinator, ChildControllerManagble {
    var parentCoordinator: ApplicationCoordinator? { get set }
}
