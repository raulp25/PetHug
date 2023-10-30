//
//  LoginViewModelFailureTests.swift
//  pethugTests
//
//  Created by Raul Pena on 30/10/23.
//

import XCTest
import UIKit
import Combine

@testable import pethug


class LoginViewModelFailureTests: XCTestCase {
    private var authServiceMock: AuthServiceFailureMock!
    private var vm: LoginViewModel!
    private var stateSpy: StateValueSpy!
    
    override func setUp() {
        authServiceMock = AuthServiceFailureMock()
        vm = LoginViewModel(authService: authServiceMock)
        stateSpy = StateValueSpy(vm.state.eraseToAnyPublisher())
    }
    
    override func tearDown() {
        NetworkMonitor.shared.connect()
        vm = nil
        stateSpy = nil
    }
    
    //MARK: - From validation
    
    func test_with_failure_Login_with_wrong_data() async {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong)], "The published value should be equal to [.error(.someThingWentWrong]")
        }
        
        await vm.login(email: nil, password: "fakePassword")
    }
    
    func test_with_failure_Login() async {
        
        defer {
            XCTAssertEqual(stateSpy.values, [.error(.someThingWentWrong)], "The published value should be equal to [.error(.someThingWentWrong]")
        }
        
        await vm.login(email: "fakeEmail@gmail.com", password: "fakePassword")
    }
    
    func test_with_networkFailure_Login() async {
        NetworkMonitor.shared.disconnect()
        
        defer {
            XCTAssertEqual(stateSpy.values, [.networkError], "The published value should be equal to [.networkError]")
        }
        
        await vm.login(email: "fakeEmail@gmail.com", password: "fakePassword")
    }
}

//MARK: - Combine publisher Spy

private class StateValueSpy {
    private(set) var values = [LoginViewModel.State]()
    private var cancellable: AnyCancellable?
    
    init(_ publisher: AnyPublisher<LoginViewModel.State, Never>) {
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
