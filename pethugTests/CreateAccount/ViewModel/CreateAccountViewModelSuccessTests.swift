//
//  CreateAccountViewModelSuccessTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug


class CreateAccountViewModelSuccessTests: XCTestCase {
    private var authServiceMock: AuthServiceSuccessMock!
    private var imageServiceMock: ImageServiceSuccessMock!
    private var defaultUserDataSource: DefaultUserDataSourceSuccessMock!
    private var defaultUserRepositoryMock: DefaultUserRepositorySuccessMock!
    private var vm: CreateAccountViewModel!
    private var stateSpy: StateValueSpy!
    
    override func setUp() {
        authServiceMock = AuthServiceSuccessMock()
        imageServiceMock = ImageServiceSuccessMock()
        defaultUserDataSource = DefaultUserDataSourceSuccessMock()
        defaultUserRepositoryMock = DefaultUserRepositorySuccessMock(userDataSource: defaultUserDataSource)
        vm = CreateAccountViewModel(authService: authServiceMock,
                                    imageService: imageServiceMock,
                                    registerUserUC: DefaultRegisterUserUC.init(userRepository: defaultUserRepositoryMock))
        stateSpy = StateValueSpy(vm.state.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        vm = nil
        stateSpy = nil
    }
    
    
    func test_with_successfull_Create_Account() async {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.success], "The published value should be equal to [.success]")
        }
        
        await vm.crateAccount(username: "vim", email: "slr@gmail.com", password: "fakepass")
    }
}

//MARK: - Combine publisher Spy

private class StateValueSpy {
    private(set) var values = [CreateAccountViewModel.State]()
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<CreateAccountViewModel.State, Never>) {
        cancellable = publisher
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .success:
                    self?.values.append(.success)
                default:
                    print("not an error log")
                }
            })
    }
}
 

