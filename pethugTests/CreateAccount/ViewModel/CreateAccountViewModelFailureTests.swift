//
//  CreateAccountViewModelFailureTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug


class CreateAccountViewModelFailureTests: XCTestCase {
    private var authServiceMock: AuthServiceSuccessMock!
    private var imageServiceMock: ImageServiceSuccessMock!
    private var defaultUserDataSource: DefaultUserDataSourceFailureMock!
    private var defaultUserRepositoryMock: DefaultUserRepositoryFailureMock!
    private var vm: CreateAccountViewModel!
    private var stateSpy: StateValueSpy!
    
    override func setUp() {
        authServiceMock = AuthServiceSuccessMock()
        imageServiceMock = ImageServiceSuccessMock()
        defaultUserDataSource = DefaultUserDataSourceFailureMock()
        defaultUserRepositoryMock = DefaultUserRepositoryFailureMock(userDataSource: defaultUserDataSource)
        vm = CreateAccountViewModel(authService: authServiceMock,
                                    imageService: imageServiceMock,
                                    registerUserUC: DefaultRegisterUserUC.init(userRepository: defaultUserRepositoryMock))
        stateSpy = StateValueSpy(vm.state.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        NetworkMonitor.shared.connect()
        vm = nil
        stateSpy = nil
    }
    
    
    func test_with_failure_Create_Account_with_wrong_data() async {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong)], "The published value should be equal to [.error(.someThingWentWrong]")
        }
        
        await vm.crateAccount(username: nil, email: "fakeEmail@gmail.com", password: nil)
    }
    
    func test_with_failure_Create_Account() async {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong)], "The published value should be equal to [.error(.someThingWentWrong]")
        }
        
        await vm.crateAccount(username: "Inzo", email: "fakeEmail@gmail.com", password: "dub8")
    }
    
    func test_with_networkFailure_Login() async {
        NetworkMonitor.shared.disconnect()
        
        defer {
            XCTAssertEqual(stateSpy.values, [.networkError], "The published value should be equal to [.networkError]")
        }
        
        await vm.crateAccount(username: "Inzo", email: "fakeEmail@gmail.com", password: "dub8")
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
                case .error(_):
                    self?.values.append(.error(.someThingWentWrong))
                case .networkError:
                    self?.values.append(.networkError)
                default:
                    print("not an error log")
                }
            })
    }
}

